import 'dart:async';

import 'package:cocktails_app/data/network/cocktails_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/drink.dart';

final databaseProvider = Provider<Database>((ref) {
  throw Exception('Provider was not initialized');
});

Future<Database> initDb() async {
  final appDir = await getApplicationDocumentsDirectory();
  await appDir.create(recursive: true);
  final databasePath = join(appDir.path, "sembast.db");
  final database = await databaseFactoryIo.openDatabase(databasePath);
  return database;
}

abstract class DrinkRepository {
  Future<List<String>> insertAllDrinks(List<Drink> drinks);

  Stream<List<Drink>> getAllDrinks();

  Stream<List<Drink>> getAllFavoriteDrinks();

  Stream<Drink?> getDrink(String id);

  Future<void> setIsFavorite(String drinkId, bool isFavorite);
}

final drinkRepositoryProvider = Provider<DrinkRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiProvider);
  final repo = SembastDrinkRepository(api, db);
  return repo;
});

class SembastDrinkRepository extends DrinkRepository {
  SembastDrinkRepository(this._api, this._db);

  final CocktailsApi _api;
  final Database _db;
  final StoreRef<String, Map<String, dynamic>> _store =
      stringMapStoreFactory.store("drink_store");

  @override
  Stream<List<Drink>> getAllDrinks() {
    final cancelToken = CancelToken();

    final controller = StreamController<List<Drink>>(
        onCancel: cancelToken.cancel,
        onResume: () async {
          final response =
              await _api.fetchCocktailsByLetter('a', cancelToken: cancelToken);
          await insertAllDrinks(response.drinks);
        });
    _store
        .query()
        .onSnapshots(_db)
        .map((snapshot) => snapshot
            .map((drink) => Drink.fromJson(drink.value).copyWith(id: drink.key))
            .toList(growable: false))
        .forEach((element) {
      controller.add(element);
    });

    return controller.stream;
  }

  @override
  Future<List<String>> insertAllDrinks(List<Drink> drinks) async {
    return await _db.transaction((txn) async {
      var keys = <String>[];
      for (var drink in drinks) {
        keys.add(drink.id);
        await _store.record(drink.id).put(txn, drink.toJson());
      }
      return keys;
    });
  }

  @override
  Future<dynamic> setIsFavorite(String drinkId, bool isFavorite) async {
    final record = _store.record(drinkId);
    if (await record.exists(_db)) {
      await record.update(_db, {'is_favorite': isFavorite});
    }
  }

  @override
  Stream<Drink?> getDrink(String id) {
    final finder = Finder(filter: Filter.equals('idDrink', id));
    return _store.query(finder: finder).onSnapshot(_db).asyncMap((drink) async {
      if (drink != null) {
        return Drink.fromJson(drink.value).copyWith(id: drink.key);
      } else {
        final response = await _api.fetchCocktailsById(id);
        final drinks = response.drinks;
        if (drinks.isNotEmpty) {
          insertAllDrinks(drinks);
        }
      }
      return null;
    });
  }

  @override
  Stream<List<Drink>> getAllFavoriteDrinks() {
    final finder = Finder(filter: Filter.equals('is_favorite', true));
    return _store
        .query(finder: finder)
        .onSnapshots(_db)
        .map((snapshot) => snapshot
        .map((drink) => Drink.fromJson(drink.value).copyWith(id: drink.key))
        .toList(growable: false));
  }
}

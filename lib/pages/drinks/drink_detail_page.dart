import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails_app/data/local/database.dart';
import 'package:cocktails_app/data/models/filter_response.dart';
import 'package:cocktails_app/data/network/cocktails_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/drink.dart';
import '../../router/app_router.dart';

final drinkByIdProvider = StreamProvider.family<Drink?, String>((ref, id) {
  final repo = ref.watch(drinkRepositoryProvider);
  return repo.getDrink(id);
});

final similarDrinksProvider =
    StreamProvider.family<List<FilteredDrink>, String>((ref, id) {
  return ref.watch(drinkByIdProvider(id)).when(
      error: (error, stackTrace) => Stream.error(error, stackTrace),
      loading: () => const Stream.empty(),
      data: (drink) {
        if (drink == null) return const Stream.empty();
        final api = ref.watch(apiProvider);
        final ingredients = getIngredientsList(drink);
        final cancelToken = CancelToken();
        final future = api.fetchDrinksByFilter(
            cancelToken: cancelToken,
            category: drink.category,
            ingredient: ingredients.first);
        return Stream.fromFuture(future).map((response){
          final drinks = [...response.drinks];
          drinks.shuffle();
          return drinks;
        });
      });
});

class DrinksDetailsPage extends ConsumerWidget {
  final String drinkId;

  const DrinksDetailsPage({Key? key, @PathParam() required this.drinkId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(drinkByIdProvider(drinkId));
    return repo.when(
      data: (drink) {
        if (drink == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return DrinkDetailsContent(drink);
        }
      },
      error: (err, stack) {
        return Center(child: Text(err.toString()));
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DrinkDetailsContent extends ConsumerWidget {
  final Drink _drink;

  const DrinkDetailsContent(this._drink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(drinkRepositoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            leading: const AutoBackButton(),
            expandedHeight: 300,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    repo.setIsFavorite(_drink.id, !_drink.isFavorite);
                  },
                  child: !_drink.isFavorite
                      ? const Icon(Icons.favorite_outline)
                      : const Icon(Icons.favorite),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: _drink.thumb,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DrinkDesc(_drink),
          )
        ],
      ),
    );
  }
}

class DrinkDesc extends ConsumerWidget {
  final Drink _drink;

  const DrinkDesc(this._drink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarDrinks = ref.watch(similarDrinksProvider(_drink.id));
    final ingredients = getIngredientsList(_drink);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _drink.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 40),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(_drink.category),
                    avatar: const Icon(
                      Icons.category,
                      size: 16,
                    ),
                    elevation: 4,
                    labelPadding: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(8),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(_drink.glass),
                    avatar: const Icon(
                      Icons.nightlife,
                      size: 16,
                    ),
                    elevation: 4,
                    labelPadding: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(8),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _drink.instruction,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: <Widget>[
                  ...ingredients.map(
                    (ing) => Chip(
                      label: Text(
                        ing,
                        style: const TextStyle(color: Colors.white),
                      ),
                      elevation: 4,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Похожие напитки",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        similarDrinks.when(
          data: (data) {
            return SizedBox(
              height: 220,
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final filtered = data[index];
                    return GestureDetector(
                      onTap: () => context.router
                          .push(DrinksDetailsRoute(drinkId: filtered.id)),
                      child: SizedBox(
                        width: 150,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CachedNetworkImage(
                                imageUrl: filtered.thumb,
                                height: 150,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        filtered.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          },
          error: (err, trace) => Text(trace.toString()),
          loading: () => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: LinearProgressIndicator()),
          ),
        ),
      ],
    );
  }
}

List<String> getIngredientsList(Drink drink) {
  List<String> list = [];
  final json = drink.toJson();
  for (var i = 1; i <= 5; i++) {
    final value = json['strIngredient$i'];
    if (value != null) {
      list.add(value);
    }
  }
  return list;
}

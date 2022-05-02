import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails_app/data/local/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/drink.dart';

final drinkByIdProvider =
    StreamProvider.autoDispose.family<Drink?, String>((ref, id) {
  final repo = ref.watch(drinkRepositoryProvider);
  return repo.getDrink(id);
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
          return const Center(child: Text('Drink to found'));
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

class DrinkDetailsContent extends StatelessWidget {
  final Drink _drink;

  const DrinkDetailsContent(this._drink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(_drink.name),
      //   leading: const AutoBackButton(),
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              leading: const AutoBackButton(),
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(_drink.name),
                background: CachedNetworkImage(
                  imageUrl: _drink.thumb,
                  width: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            ),
          ];
        },
        body: Center(child: Text(_drink.toString())),
      ),
    );
  }
}

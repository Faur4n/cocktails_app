import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails_app/data/local/database.dart';
import 'package:cocktails_app/data/network/cocktails_api.dart';
import 'package:cocktails_app/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/drink.dart';

final drinksByLetter =
    StreamProvider.autoDispose.family<List<Drink>, String>((ref, letter) {
  final repo = ref.watch(drinkRepositoryProvider);
  try {
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final api = ref.watch(apiProvider);
    final response = api.fetchCocktailsByLetter('a', cancelToken: cancelToken);
    response.then((value) => repo.insertAllDrinks(value.drinks));
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return repo.getAllDrinks();
});

class DrinksPage extends ConsumerWidget {
  const DrinksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(drinksByLetter('a'));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Drinks'),
        leading: const AutoBackButton(),
      ),
      body: Container(
        child: data.when(
          data: (data) {
            return DrinksList(data);
          },
          error: (err, stack) {
            return Text('Error $err');
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class DrinksList extends StatelessWidget {
  final List<Drink> _drinks;

  const DrinksList(this._drinks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _drinks.length,
      itemBuilder: (BuildContext context, int index) =>
          DrinkCard(_drinks[index]),
    );
  }
}

class DrinkCard extends StatelessWidget {
  final Drink _drink;

  const DrinkCard(this._drink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(DrinksDetailsRoute(drinkId: _drink.id)),
      child: CardWithSideImage(
        image: CachedNetworkImage(
          imageUrl: _drink.thumb,
          width: 150,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        content: DrinkSmallDescription(_drink),
      ),
    );
  }
}

class DrinkSmallDescription extends ConsumerWidget {
  final Drink _drink;

  const DrinkSmallDescription(this._drink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(drinkRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                title: Text(_drink.name),
                subtitle: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: _drink.category,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: " ${_drink.glass}",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_drink.instruction,
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black.withOpacity(0.6))),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ButtonBar(
              key: ValueKey(_drink.isFavorite),
              children: [
                TextButton.icon(
                    onPressed: () async {
                      await repo.setIsFavorite(_drink.id, !_drink.isFavorite);
                    },
                    icon: !_drink.isFavorite
                        ? const Icon(Icons.favorite_outline)
                        : const Icon(Icons.favorite),
                    label: !_drink.isFavorite
                        ? const Text('В избранное')
                        : const Text('Сохранено'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardWithSideImage extends StatelessWidget {
  final Widget image;
  final Widget content;

  const CardWithSideImage(
      {Key? key, required this.image, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [image, Expanded(child: content)],
        ),
      ),
    );
  }
}

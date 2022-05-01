import 'package:cocktails_app/data/cocktails_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/drinks_response.dart';

final drinksByLetter = FutureProvider.autoDispose
    .family<DrinksResponse, String>((ref, letter) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final api = ref.watch(apiProvider);
  final response =
      await api.fetchCocktailsByLetter('a', cancelToken: cancelToken);
  ref.keepAlive();
  return response;
});

class DrinksPage extends ConsumerWidget {
  const DrinksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(drinksByLetter('a'));
    return Container(
        child: data.when(
            data: (data) {
              return DrinksList(data.drinks);
            },
            error: (err, stack) {
              return Text('Error $err');
            },
            loading: () => const Center(child: CircularProgressIndicator())));
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
    return CardWithSideImage(
      image: Image.network(
        _drink.thumb,
        width: 150,
        fit: BoxFit.cover,
      ),
      content: DrinkSmallDescription(_drink),
    );
  }
}

class DrinkSmallDescription extends StatelessWidget {
  final Drink _drink;

  const DrinkSmallDescription(this._drink, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ButtonBar(
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  label: const Text('В избранное'))
            ],
          ),
        ],
      ),
    );
  }
}

class CardWithSideImage extends StatelessWidget {
  final Image image;
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

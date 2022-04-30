import 'package:cocktails_app/data/cocktails_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/drinks_response.dart';

final cocktailsByLetter = FutureProvider.autoDispose
    .family<DrinksResponse, String>((ref, letter) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final api = ref.watch(apiProvider);
  final response =
      await api.fetchCocktailsByLetter('a', cancelToken: cancelToken);
  ref.keepAlive();
  return response;
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(cocktailsByLetter('a'));
    return Container(
        child: data.when(
            data: (data) {
              return DrinksList(drinks: data.drinks);
            },
            error: (err, stack) {
              return Text('Error $err');
            },
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}

class DrinksList extends StatelessWidget {
  final List<Drink> drinks;

  const DrinksList({Key? key, required this.drinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: drinks.length,
      itemBuilder: (BuildContext context, int index) =>
          DrinkCard(drink: drinks[index]),
    );
  }
}

class DrinkCard extends StatelessWidget {
  final Drink drink;

  const DrinkCard({Key? key, required this.drink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.network(
                drink.thumb,
                width: 150,
                fit: BoxFit.cover,
              ),
              Expanded(
                  child: Column(children: [
                    ListTile(
                      title: Text(drink.name),
                      subtitle: Text.rich(TextSpan(
                        children: <InlineSpan>[
                            TextSpan(text: drink.category,style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " ${drink.glass}",style: TextStyle(color: Colors.black.withOpacity(0.6)))
                        ]
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(drink.instruction,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black.withOpacity(0.6))),
                    )
                  ])
              )
          ]),
        const Divider(height: 0),
        ButtonBar(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Perform some action
                },
                label: const Text('В избранное'),
              ),
              TextButton.icon(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // Perform some action
                },
                label: const Text('Подробнее'),
              ),
            ],
          )
        ],
      )
    );
  }
}

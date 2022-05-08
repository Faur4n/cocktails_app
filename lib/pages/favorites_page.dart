import 'package:auto_route/auto_route.dart';
import 'package:cocktails_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import 'drinks/drinks_page.dart';

final favoriteDrinksProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(drinkRepositoryProvider);
  return repo.getAllFavoriteDrinks();
});

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(favoriteDrinksProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Избранное'),
        leading: const AutoBackButton(),
      ),
      body: Center(
        child: data.when(
          data: (data) {
            if (data.isNotEmpty) {
              return DrinksList(data);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Нет сохраненных напитков'),
                  const SizedBox(height: 8),
                  TextButton(
                      onPressed: (){
                        final router = context.router.root.innerRouterOf<TabsRouter>(MainRoute.name);
                        router?.setActiveIndex(0);
                      },
                      child: const Text('Искать напитки'))
                ],
              );
            }
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

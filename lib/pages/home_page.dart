import 'package:cocktails_app/data/CocktailsApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cocktailsByLetter =
    FutureProvider.autoDispose.family<String, String>((ref, letter) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final api = ref.watch(apiProvider);
  final response =
      await api.fetchCocktailsByLetter('a', cancelToken: cancelToken);
  ref.keepAlive();
  return response.toString();
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(cocktailsByLetter('a'));
    return Container(
        padding: const EdgeInsets.fromLTRB(10,10,10,0),
        child: data.when(
            data: (data) {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(data)
              );
            },
            error: (err, stack) {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text('Error $err')
              );
            },
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}

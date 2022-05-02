import 'package:auto_route/auto_route.dart';
import 'package:cocktails_app/data/local/database.dart';
import 'package:cocktails_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
  final db = await initDb();
  runApp(ProviderScope(
    child: AppWidget(),
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
  ));
}

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'CocktailsDB',
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRouter(), FavoritesRouter(), RandomRouter()],
      bottomNavigationBuilder: (_, tabsRouter) => BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_drink), label: 'Напитки'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_mark), label: 'Случайный')
        ],
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
      ),
      // appBarBuilder: (_, tabRouter) => AppBar(
      //   centerTitle: true,
      //
      //   title: const Text('CocktailsDB'),
      //   leading: const AutoBackButton(),
      // ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cocktails_app/pages/drinks/drinks_page.dart';
import 'package:flutter/cupertino.dart';
import '../pages/drinks/drink_detail_page.dart';
import '../pages/favorites_page.dart';
import '../main.dart';
import '../pages/random_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: MainPage, path: '/', children: [
      AutoRoute(
          path: 'home',
          name: 'HomeRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: DrinksPage),
            AutoRoute(path: ':drinkId', page: DrinksDetailsPage),
          ]
      ),
      AutoRoute(
        path: 'favorites',
        name: 'FavoritesRouter',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: FavoritesPage),
        ],
      ),
      AutoRoute(
        path: 'random',
        name: 'RandomRouter',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: RandomPage),
        ],
      ),
    ]),
  ],
)
class AppRouter extends _$AppRouter {}

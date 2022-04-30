// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const MainPage());
    },
    HomeRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    FavoritesRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    RandomRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomePage());
    },
    FavoritesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const FavoritesPage());
    },
    RandomRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const RandomPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(MainRoute.name, path: '/', children: [
          RouteConfig(HomeRouter.name,
              path: 'home',
              parent: MainRoute.name,
              children: [
                RouteConfig(HomeRoute.name, path: '', parent: HomeRouter.name)
              ]),
          RouteConfig(FavoritesRouter.name,
              path: 'favorites',
              parent: MainRoute.name,
              children: [
                RouteConfig(FavoritesRoute.name,
                    path: '', parent: FavoritesRouter.name)
              ]),
          RouteConfig(RandomRouter.name,
              path: 'random',
              parent: MainRoute.name,
              children: [
                RouteConfig(RandomRoute.name,
                    path: '', parent: RandomRouter.name)
              ])
        ])
      ];
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(MainRoute.name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for
/// [EmptyRouterPage]
class HomeRouter extends PageRouteInfo<void> {
  const HomeRouter({List<PageRouteInfo>? children})
      : super(HomeRouter.name, path: 'home', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [EmptyRouterPage]
class FavoritesRouter extends PageRouteInfo<void> {
  const FavoritesRouter({List<PageRouteInfo>? children})
      : super(FavoritesRouter.name,
            path: 'favorites', initialChildren: children);

  static const String name = 'FavoritesRouter';
}

/// generated route for
/// [EmptyRouterPage]
class RandomRouter extends PageRouteInfo<void> {
  const RandomRouter({List<PageRouteInfo>? children})
      : super(RandomRouter.name, path: 'random', initialChildren: children);

  static const String name = 'RandomRouter';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [FavoritesPage]
class FavoritesRoute extends PageRouteInfo<void> {
  const FavoritesRoute() : super(FavoritesRoute.name, path: '');

  static const String name = 'FavoritesRoute';
}

/// generated route for
/// [RandomPage]
class RandomRoute extends PageRouteInfo<void> {
  const RandomRoute() : super(RandomRoute.name, path: '');

  static const String name = 'RandomRoute';
}

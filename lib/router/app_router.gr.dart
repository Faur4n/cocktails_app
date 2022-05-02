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
    DrinksRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DrinksPage());
    },
    DrinksDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DrinksDetailsRouteArgs>(
          orElse: () =>
              DrinksDetailsRouteArgs(drinkId: pathParams.getString('drinkId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: DrinksDetailsPage(key: args.key, drinkId: args.drinkId));
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
                RouteConfig(DrinksRoute.name,
                    path: '', parent: HomeRouter.name),
                RouteConfig(DrinksDetailsRoute.name,
                    path: ':drinkId', parent: HomeRouter.name)
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
/// [DrinksPage]
class DrinksRoute extends PageRouteInfo<void> {
  const DrinksRoute() : super(DrinksRoute.name, path: '');

  static const String name = 'DrinksRoute';
}

/// generated route for
/// [DrinksDetailsPage]
class DrinksDetailsRoute extends PageRouteInfo<DrinksDetailsRouteArgs> {
  DrinksDetailsRoute({Key? key, required String drinkId})
      : super(DrinksDetailsRoute.name,
            path: ':drinkId',
            args: DrinksDetailsRouteArgs(key: key, drinkId: drinkId),
            rawPathParams: {'drinkId': drinkId});

  static const String name = 'DrinksDetailsRoute';
}

class DrinksDetailsRouteArgs {
  const DrinksDetailsRouteArgs({this.key, required this.drinkId});

  final Key? key;

  final String drinkId;

  @override
  String toString() {
    return 'DrinksDetailsRouteArgs{key: $key, drinkId: $drinkId}';
  }
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

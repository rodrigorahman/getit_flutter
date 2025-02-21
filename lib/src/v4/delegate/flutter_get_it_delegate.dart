import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../router/seed/flutter_get_it_custom_route.dart';
import '../router/seed/flutter_get_it_material_route.dart';
import '../widgets/flutter_get_it_middleware_loader.dart';

class FGetItRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  FGetItRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    List<FlutterGetItRouteBase> routes = const [],
    ApplicationBindings? applicationBindings,
    List<FlutterGetItMiddleware> middlewares = const [],
    String initialRoute = '/',
    this.loaderBuilder,
  }) : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    final logger = FGetItLogger(
      FGetItLoggerConfig(),
      middlewares.map((e) => e.runtimeType).toList(),
    );
    final wallet = FlutterGetItWallet(
      routes: routes,
      applicationMiddlewares: middlewares,
      applicationBindings: applicationBindings,
      navigatorKey: _navigatorKey,
      initialRoute: initialRoute,
    );
    GetIt.I.registerSingleton(logger);
    GetIt.I.registerSingleton(wallet);
    _routeObserver = FlutterGetItRouteObserver();
  }

  late final FlutterGetItRouteObserver _routeObserver;
  late final GlobalKey<NavigatorState> _navigatorKey;
  final Widget Function(Stream<Type> stream)? loaderBuilder;

  @override
  Future<void> setNewRoutePath(String configuration) async {
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      observers: [_routeObserver],
      onGenerateRoute: (settings) {
        final route =
            GetIt.I.get<FlutterGetItWallet>().getRoute(settings.name ?? '');
        if (route == null) {
          return null;
        }

        final routeSolved = _solveNavigation(
          route as FlutterGetItRoute,
          settings.arguments,
        );
        SystemNavigator.routeInformationUpdated(
          uri: Uri.parse(routeSolved.fullPath),
          state: settings.arguments,
        );

        return switch (routeSolved.isCustom) {
          true => FlutterGetItCustomRoute(
              route: routeSolved,
              settings: settings,
            ),
          false => FlutterGetItMaterialRoute(
              route: routeSolved,
              settings: settings,
            ),
        };
      },
      onUnknownRoute: (settings) {
        const tip = 'Check your route name, e be sure that it\'s exists.';
        final description =
            'Are you trying to navigate to "${settings.name ?? 'NO NAME PROVIDED'}"? And we can\'t find it.';
        return FlutterGetItMaterialRoute(
          route: FlutterGetItRoute(
            path: settings.name ?? '',
            buildPage: (context, animation, secondaryAnimation, params) =>
                FlutterGetItErrorPage(
              exception: null,
              stackTrace: null,
              tip: tip,
              description: description,
            ),
          ),
          settings: settings,
        );
      },
    );
  }

  FlutterGetItRoute _solveNavigation(
      FlutterGetItRoute route, dynamic arguments) {
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();

    final isMoreThenOneRouteLikeMe =
        fGetItWallet.isMoreThenOneRouteLikeMe(route.fullPath);
    final lastRouteWasLoader = fGetItWallet.lastRouteWasLoader;

    if (lastRouteWasLoader) {
      fGetItWallet.addRouteStack(route);
      return route;
    }

    if (isMoreThenOneRouteLikeMe) {
      fGetItWallet.initBinds(route: route);
      return route;
    }

    final appMiddlewares = fGetItWallet.applicationMiddlewares;
    final parentsMiddlewares =
        fGetItWallet.getParentMiddlewares(route.fullPath);
    final routeMiddlewares = fGetItWallet.getRouteMiddlewares(route.fullPath);

    final anyMiddlewareIsAsync = appMiddlewares
            .any((middleware) => middleware is FlutterGetItAsyncMiddleware) ||
        parentsMiddlewares
            .any((middleware) => middleware is FlutterGetItAsyncMiddleware) ||
        routeMiddlewares
            .any((middleware) => middleware is FlutterGetItAsyncMiddleware);

    final anyBindAsyncDontInitialized =
        fGetItWallet.anyBindAsyncDontInitialized(route);
    FGetItLogger.logInitDivider();
    switch ((anyMiddlewareIsAsync, anyBindAsyncDontInitialized)) {
      case (true, true):
        FGetItLogger.logInformThatTheNewRouteIsAsync(
          route.fullPath,
          'AsyncMiddlewares && AsyncBinds',
        );
        return _getLoaderPageRoute(route, arguments);
      case (false, true):
        FGetItLogger.logInformThatTheNewRouteIsAsync(
          route.fullPath,
          'AsyncBinds',
        );
        return _getLoaderPageRoute(route, arguments);
      case (true, false):
        FGetItLogger.logInformThatTheNewRouteIsAsync(
          route.fullPath,
          'AsyncMiddlewares',
        );
        return _getLoaderPageRoute(route, arguments);
      case (false, false):
        FGetItLogger.logInformThatTheNewRouteIsSync(route.fullPath);
        fGetItWallet.addRouteStack(route);
        return route;
    }
  }

  FlutterGetItRoute _getLoaderPageRoute(
    FlutterGetItRoute routeToSolve,
    dynamic arguments,
  ) {
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
    final loaderPage = FlutterGetItRoute(
      path: routeToSolve.path,
      barrierColor: Colors.black,
      buildPage: (context, animation, secondaryAnimation, params) =>
          FlutterGetItMiddlewareLoader(
        routeToSolve: routeToSolve,
        loaderBuilder: loaderBuilder,
      ),
      buildTransition: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
    loaderPage.fullPath = routeToSolve.fullPath;
    loaderPage.isLoader = true;
    fGetItWallet.addRouteStack(loaderPage);
    return loaderPage;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}

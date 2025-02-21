import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../../routers/flutter_get_it_route_params_extractor.dart';

typedef RouteAndParentBinds = ({
  FlutterGetItRouteBase? route,
  List<Bind> parentBinds,
});

class FlutterGetItWallet {
  late final Map<String, FlutterGetItRouteBase> _wallet;
  late final List<FlutterGetItMiddleware> _applicationMiddlewares;
  late final GlobalKey<NavigatorState> _navigatorKey;
  final List<FlutterGetItRouteBase> _routeStack = [];
  late final String _initialRoute;
  late final List<Bind> _applicationBinds;

  FlutterGetItWallet({
    ApplicationBindings? applicationBindings,
    required List<FlutterGetItRouteBase> routes,
    required List<FlutterGetItMiddleware> applicationMiddlewares,
    required GlobalKey<NavigatorState> navigatorKey,
    required String initialRoute,
  }) {
    _createRouteMap(routes);
    _applicationMiddlewares = applicationMiddlewares;
    _navigatorKey = navigatorKey;
    _initialRoute = initialRoute;
    _applicationBinds = applicationBindings?.bindings() ?? [];
  }

  List<FlutterGetItRouteBase> get routeStack => _routeStack;

  String get initialRoute => _initialRoute;

  void addRouteStack(FlutterGetItRouteBase route) {
    _routeStack.add(route);
  }

  bool isMoreThenOneRouteLikeMe(String fullPath) {
    return _routeStack
        .where((element) => element.fullPath == fullPath && !element.isLoader)
        .isNotEmpty;
  }

  List<FlutterGetItMiddleware> get applicationMiddlewares =>
      _applicationMiddlewares;

  Map<String, FlutterGetItRouteBase> get wallet => _wallet;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool get lastRouteWasLoader =>
      _routeStack.isNotEmpty && _routeStack.last.isLoader;

  FlutterGetItRouteBase? getRoute(String path) {
    final params = FlutterGetItRouteParamsExtractor(
      path,
      path,
    );

    final route = _wallet[path] ?? matchRoute(path);

    if (route is FlutterGetItModuleRoute) {
      if (route.fullPath == route.redirect) {
        //Avoid infinite loop
        return route;
      }
      return getRoute(route.redirect ?? '');
    }

    return route;
  }

  FlutterGetItRouteBase? matchRoute(String inputRoute) {
    for (var definedRoute in _wallet.keys) {
      final inputSegments = inputRoute.split('/');
      final definedSegments = definedRoute.split('/');

      if (inputSegments.length != definedSegments.length) {
        continue;
      }

      final parameters = <String, String>{};
      var isMatch = true;

      for (var i = 0; i < inputSegments.length; i++) {
        final inputSegment = inputSegments[i];
        final definedSegment = definedSegments[i];

        if (definedSegment.startsWith(':')) {
          // É um parâmetro dinâmico
          final paramName = definedSegment.substring(1);
          parameters[paramName] = inputSegment;
        } else if (inputSegment != definedSegment) {
          // Segmentos não correspondem
          isMatch = false;
          break;
        }
      }

      if (isMatch) {
        return _wallet[definedRoute]!..fullPath = inputRoute;
      }
    }

    return null;
  }

  List<Bind> getParentBinds(String path) {
    final route = _wallet[path];
    final parentBinds = <Bind>[];

    _wallet.forEach((key, routeInternal) {
      if ((route?.parentUUIDs.contains(routeInternal.uuid) ?? false) &&
          routeInternal.uuid != route?.uuid) {
        parentBinds.addAll(routeInternal.binds);
      }
    });

    return parentBinds;
  }

  List<FlutterGetItMiddleware> getParentMiddlewares(String path) {
    final route = _wallet[path];
    final parentMiddlewares = <FlutterGetItMiddleware>[];
    _wallet.forEach((key, routeInternal) {
      if ((route?.parentUUIDs.contains(routeInternal.uuid) ?? false) &&
          routeInternal.uuid != route?.uuid) {
        parentMiddlewares.addAll(routeInternal.middlewares);
      }
    });
    return parentMiddlewares;
  }

  void _createRouteMap(List<FlutterGetItRouteBase> routes) {
    final routeMap = <String, FlutterGetItRouteBase>{};
    final currentModuleUuids = <String>[]; // Stack to store parent module UUIDs

    for (var routeBase in routes) {
      if (routeBase is FlutterGetItModuleRoute) {
        currentModuleUuids.add(routeBase.uuid); // Add current module's uuid
      }

      routeBase.parentUUIDs = List.unmodifiable(currentModuleUuids);
      routeBase.fullPath = routeBase.path;

      if (routeBase is FlutterGetItRoute) {
        routeMap[routeBase.path] = routeBase;
      } else if (routeBase is FlutterGetItModuleRoute) {
        routeMap[routeBase.path] = routeBase;
        for (var page in routeBase.pages) {
          page.parentUUIDs = List.unmodifiable(currentModuleUuids);
          page.fullPath = '${routeBase.path}${page.path}';
          routeMap['${routeBase.path}${page.path}'] = page;
        }
      }

      if (routeBase is FlutterGetItModuleRoute) {
        currentModuleUuids
            .removeLast(); // Remove current module's uuid after processing its pages
      }
    }

    _wallet = routeMap;
  }

  List<FlutterGetItMiddleware> getRouteMiddlewares(String routeName) {
    final route = _wallet[routeName];
    return route?.middlewares ?? [];
  }

  List<Bind> getRouteBindings(String path) {
    final route = _wallet[path];
    return route?.binds ?? [];
  }

  bool anyBindAsyncDontInitialized(FlutterGetItRouteBase? route) {
    final routeBinds = route?.binds ?? [];
    final parentBinds = getParentBinds(route?.fullPath ?? '');

    final allBinds = [...routeBinds, ...parentBinds];

    return allBinds.any((bind) =>
        (bind.type == RegisterType.factoryAsync ||
            bind.type == RegisterType.singletonAsync ||
            bind.type == RegisterType.lazySingletonAsync) &&
        !bind.isInitialized);
  }

  FutureOr<void> initBinds({
    required FlutterGetItRouteBase route,
  }) async {
    final isTheInitialRoute = route.fullPath == _initialRoute;

    if (isTheInitialRoute) {
      for (var bind in _applicationBinds) {
        bind.register('APPLICATION_BINDINGS');
      }
      FGetItLogger.logSolvingAsyncDependenciesFor('APPLICATION_BINDINGS');
      await GetIt.I.allReady().then((value) {
        FGetItLogger.logSolvingAsyncDependenciesCompleted(
          'APPLICATION_BINDINGS',
        );
      });
      return;
    }

    FGetItLogger.logInitDivider();

    //Init parent binds
    final parentBinds = getParentBinds(route.fullPath);

    for (var bind in parentBinds) {
      bind.register(route.fullPath);
    }

    //Init route binds
    for (var bind in route.binds) {
      bind.register(route.fullPath);
    }
    FGetItLogger.logSolvingAsyncDependenciesFor(route.fullPath);
    await GetIt.I.allReady().then((value) {
      FGetItLogger.logSolvingAsyncDependenciesCompleted(route.fullPath);
    });
    FGetItLogger.logEndDivider();

    return;
  }

  void removeLastRouteStack() {
    _routeStack.removeLast();
  }

  void solveDisposeRoute(FlutterGetItRouteBase route) {
    //Unregister parent binds
    FGetItLogger.logInitDivider();
    FGetItLogger.logCallingDisposeRoute(route.fullPath);
    FGetItLogger.logMidDivider();

    for (var bind in getParentBinds(route.fullPath)) {
      bind.unRegister(route.fullPath);
    }

    //Unregister route binds
    for (var bind in route.binds) {
      bind.unRegister(route.fullPath);
    }

    FGetItLogger.logEndDivider();
  }
}

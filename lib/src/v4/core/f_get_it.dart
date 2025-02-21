import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../../helper/flutter_get_it_helper.dart';

class FGetIt {
  static bool isRegistered<T extends Object>({String? tag}) {
    return GetIt.I.isRegistered<Bind<T>>(instanceName: tag);
  }

  //static dynamic get arguments => FlutterGetItBindingOpened.argument;

  static bool any<T extends Object>() {
    return GetIt.I.getAll<Bind<T>>().isNotEmpty;
  }

  static T get<T extends Object>({
    String? tag,
    String? factoryTag,
  }) {
    try {
      final getIt = GetIt.I;
      FlutterGetItHelper.throwIfNot(
        getIt.isRegistered<Bind<T>>(
          instanceName: tag,
        ),
        FlutterError(
          'The type $T is not registered in the FlutterGetIt, please check if it is registered in the module or in the main.',
        ),
      );

      return getIt.get<Bind<T>>(instanceName: tag).getInstance();
    } on AssertionError catch (e) {
      FGetItLogger.logErrorInGetInstance<T>(
        e.toString(),
        tag: tag,
        factoryTag: factoryTag,
      );
      rethrow;
    }
  }

  static Future<T> getAsync<T extends Object>(
      {String? tag, String? factoryTag}) async {
    try {
      FGetItLogger.logGettingAsyncInstance<T>(tag: tag, factoryTag: factoryTag);

      return await GetIt.I.isReady<T>(instanceName: tag).then((_) {
        FGetItLogger.logAsyncInstanceReady<T>(
          tag: tag,
          factoryTag: factoryTag,
        );

        return get<Bind<T>>(tag: tag, factoryTag: factoryTag).getInstance();
      });
    } on AssertionError catch (e) {
      FGetItLogger.logErrorInGetAsyncInstance<T>(
        e.toString(),
        tag: tag,
        factoryTag: factoryTag,
      );
      throw Exception('${T.toString()} not found in FlutterGetIt');
    }
  }

  static Future<void> allReady() async {
    FGetItLogger.logWaitingAllReady();

    await GetIt.I.allReady().then((value) {
      FGetItLogger.logWaitingAllReadyCompleted();
    });
  }

  T call<T extends Object>({String? tag, String? factoryTag}) =>
      get<T>(tag: tag, factoryTag: factoryTag);

  static void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
    final route = fGetItWallet.routeStack.last;
    properties.add(DiagnosticsProperty<FlutterGetItRouteBase>(
      'Route',
      route,
    ));
  }
}

extension FGetItContext on BuildContext {
  T get<T extends Object>({String? tag, String? factoryTag}) =>
      FGetIt.get<T>(tag: tag, factoryTag: factoryTag);

  Future<T> getAsync<T extends Object>({String? tag, String? factoryTag}) =>
      FGetIt.getAsync<T>(tag: tag, factoryTag: factoryTag);

  bool isRegistered<T extends Object>({String? tag}) =>
      FGetIt.isRegistered<T>(tag: tag);

  bool any<T extends Object>() => FGetIt.any<T>();
/* 
  /// All bellow is for the navigator
  NavigatorState get _navigator =>
      GetIt.I.get<FlutterGetItWallet>().navigatorKey.currentState!;
  static dynamic _arguments;
  dynamic get arguments => _arguments;
  //set arguments(dynamic value) => _arguments = value;

  void _openLoader() {
    showDialog(
      barrierDismissible: false,
      context: _navigator.context,
      builder: (context) => const Center(
        child: Card(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        )),
      ),
    );
  }

  void _closeLoader() {
    Navigator.of(_navigator.context).pop();
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    _arguments = arguments;
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
    final appMiddlewares = fGetItWallet.applicationMiddlewares;
    final parentsMiddlewares = fGetItWallet.getParentMiddlewares(routeName);
    final routeMiddlewares = fGetItWallet.getRouteMiddlewares(routeName);

    //Any async middleware?
    final anyAsyncMiddleware = appMiddlewares
            .any((middleware) => middleware is FlutterGetItAsyncMiddleware) ||
        parentsMiddlewares
            .any((middleware) => middleware is FlutterGetItAsyncMiddleware) ||
        routeMiddlewares
            .any((middleware) => middleware is FlutterGetItAsyncMiddleware);

    if (anyAsyncMiddleware) {
      _openLoader();
    }

    for (var middleware in appMiddlewares) {
      FGetItLogger.logInitMiddleware('Application Middlewares');
      if (middleware.when(routeName) == MiddlewareAction.execute) {
        FGetItLogger.logRunningMiddleware(middleware.runtimeType.toString());
        final result = await middleware.execute(arguments);
        if (result != MiddlewareStatus.success) {
          FGetItLogger.logMiddlewareFail(middleware.runtimeType.toString());
          FGetItLogger.logEndDivider();
          _closeLoader();
          return null;
        }
        FGetItLogger.logMiddlewareSuccess(middleware.runtimeType.toString());
      } else {
        FGetItLogger.logMiddlewareSkipped(middleware.runtimeType.toString());
      }
    }
    FGetItLogger.logEndDivider();

    FGetItLogger.logInitMiddleware('Parent Middlewares');
    for (var middleware in parentsMiddlewares) {
      FGetItLogger.logRunningMiddleware(middleware.runtimeType.toString());
      if (middleware.when(routeName) == MiddlewareAction.execute) {
        final result = await middleware.execute(arguments);
        if (result != MiddlewareStatus.success) {
          FGetItLogger.logMiddlewareFail(middleware.runtimeType.toString());
          FGetItLogger.logEndDivider();
          _closeLoader();
          return null;
        }
        FGetItLogger.logMiddlewareSuccess(middleware.runtimeType.toString());
      } else {
        FGetItLogger.logMiddlewareSkipped(middleware.runtimeType.toString());
      }
    }
    FGetItLogger.logEndDivider();

    FGetItLogger.logInitMiddleware('Route Middlewares');
    for (var middleware in routeMiddlewares) {
      FGetItLogger.logRunningMiddleware(middleware.runtimeType.toString());
      if (middleware.when(routeName) == MiddlewareAction.execute) {
        final result = await middleware.execute(arguments);
        if (result != MiddlewareStatus.success) {
          FGetItLogger.logMiddlewareFail(middleware.runtimeType.toString());
          FGetItLogger.logEndDivider();
          _closeLoader();
          return null;
        }
        FGetItLogger.logMiddlewareSuccess(middleware.runtimeType.toString());
      } else {
        FGetItLogger.logMiddlewareSkipped(middleware.runtimeType.toString());
      }
    }
    FGetItLogger.logEndDivider();

    await _initRoute(routeName);

    if (anyAsyncMiddleware) {
      _closeLoader();
    }

    return _navigator.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  FutureOr<void> _initRoute(String path) async {
    FGetItLogger.logInitDivider();
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();

    //Init parent binds
    final parentBinds = fGetItWallet.getParentBinds(path);
    final routeBinds = fGetItWallet.getRouteBindings(path);
    for (var bind in parentBinds) {
      bind.register(path);
    }

    //Init route binds
    for (var bind in routeBinds) {
      bind.register(path);
    }
    FGetItLogger.logSolvingAsyncDependenciesFor(path);
    await GetIt.I.allReady().then((value) {
      FGetItLogger.logSolvingAsyncDependenciesCompleted(path);
    });
    FGetItLogger.logEndDivider();
    return;
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.popAndPushNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  String? restorablePushNamed(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.restorablePushNamed(
      routeName,
      arguments: arguments,
    );
  }

  String? restorablePushReplacementNamed<T extends Object?>(
    String routeName, {
    T? result,
    Object? arguments,
  }) {
    return _navigator.restorablePushReplacementNamed<T, dynamic>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  String? restorablePopAndPushNamed<T extends Object?>(
    String routeName, {
    T? result,
    Object? arguments,
  }) {
    return _navigator.restorablePopAndPushNamed<T, dynamic>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  String? restorablePushNamedAndRemoveUntil(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator.restorablePushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    _navigator.pop(result);
  }

  void popUntil(RoutePredicate predicate) {
    _navigator.popUntil(predicate);
  }

  bool canPop() {
    return _navigator.canPop();
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    return _navigator.maybePop<T>(result);
  } */
}

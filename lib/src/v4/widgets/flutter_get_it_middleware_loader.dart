import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import 'flutter_get_it_loader.dart';

class FlutterGetItMiddlewareLoader extends StatefulWidget {
  final FlutterGetItRouteBase routeToSolve;
  final Widget Function(Stream<Type>)? loaderBuilder;
  const FlutterGetItMiddlewareLoader({
    super.key,
    required this.routeToSolve,
    this.loaderBuilder,
  });

  @override
  State<FlutterGetItMiddlewareLoader> createState() =>
      _FlutterGetItMiddlewareLoaderState();
}

class _FlutterGetItMiddlewareLoaderState
    extends State<FlutterGetItMiddlewareLoader> {
  final _streamLoader = StreamController<Type>();
  FlutterGetItRouteBase get routeToSolve => widget.routeToSolve;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMiddleware();
    });
  }

  void _loadMiddleware() async {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
    final appMiddlewares = fGetItWallet.applicationMiddlewares;

    if (routeToSolve.fullPath == fGetItWallet.initialRoute) {
      FGetItLogger.logInitDivider();
      FGetItLogger.logInitInitialRoute();
      _streamLoader.add(FlutterGetItInitializationMiddleware);
      await fGetItWallet.initBinds(route: routeToSolve);
      FGetItLogger.logEndDivider();
      fGetItWallet.navigatorKey.currentState?.popAndPushNamed(
        routeToSolve.fullPath,
        arguments: arguments,
      );

      return;
    }

    final parentsMiddlewares =
        fGetItWallet.getParentMiddlewares(routeToSolve.fullPath);
    final routeMiddlewares = routeToSolve.middlewares;

    if (appMiddlewares.isNotEmpty) {
      FGetItLogger.logInitMiddleware('Application Middlewares');

      for (var middleware in appMiddlewares) {
        if (middleware.when(routeToSolve.fullPath) ==
            MiddlewareAction.execute) {
          FGetItLogger.logRunningMiddleware(middleware.runtimeType.toString());
          _streamLoader.add(middleware.runtimeType);
          final result = await middleware.execute(arguments);
          if (result != MiddlewareStatus.success) {
            FGetItLogger.logMiddlewareFail(middleware.runtimeType.toString());
            FGetItLogger.logEndDivider();
            fGetItWallet.removeLastRouteStack();
            fGetItWallet.navigatorKey.currentState?.pop();
            //Maybe ?? Duration.zero
            if (fGetItWallet.navigatorKey.currentState!.mounted) {
              middleware.onFailure(
                fGetItWallet.navigatorKey.currentState!.context,
                arguments,
              );
            }
            return;
          }
          FGetItLogger.logMiddlewareSuccess(middleware.runtimeType.toString());
        } else {
          FGetItLogger.logMiddlewareSkipped(middleware.runtimeType.toString());
        }
      }
      FGetItLogger.logEndDivider();
    }

    if (parentsMiddlewares.isNotEmpty) {
      FGetItLogger.logInitMiddleware('Parent Middlewares');
      for (var middleware in parentsMiddlewares) {
        FGetItLogger.logRunningMiddleware(middleware.runtimeType.toString());
        if (middleware.when(routeToSolve.fullPath) ==
            MiddlewareAction.execute) {
          _streamLoader.add(middleware.runtimeType);
          final result = await middleware.execute(arguments);
          if (result != MiddlewareStatus.success) {
            FGetItLogger.logMiddlewareFail(middleware.runtimeType.toString());
            FGetItLogger.logEndDivider();
            fGetItWallet.removeLastRouteStack();
            fGetItWallet.navigatorKey.currentState?.pop();
            //Maybe ?? Duration.zero
            if (fGetItWallet.navigatorKey.currentState!.mounted) {
              middleware.onFailure(
                fGetItWallet.navigatorKey.currentState!.context,
                arguments,
              );
            }
            return;
          }
          FGetItLogger.logMiddlewareSuccess(middleware.runtimeType.toString());
        } else {
          FGetItLogger.logMiddlewareSkipped(middleware.runtimeType.toString());
        }
      }
      FGetItLogger.logEndDivider();
    }

    if (routeMiddlewares.isNotEmpty) {
      FGetItLogger.logInitMiddleware('Route Middlewares');
      for (var middleware in routeMiddlewares) {
        FGetItLogger.logRunningMiddleware(middleware.runtimeType.toString());
        if (middleware.when(routeToSolve.fullPath) ==
            MiddlewareAction.execute) {
          _streamLoader.add(middleware.runtimeType);
          final result = await middleware.execute(arguments);
          if (result != MiddlewareStatus.success) {
            FGetItLogger.logMiddlewareFail(middleware.runtimeType.toString());
            FGetItLogger.logEndDivider();
            fGetItWallet.removeLastRouteStack();
            fGetItWallet.navigatorKey.currentState?.pop();
            //Maybe ?? Duration.zero
            if (fGetItWallet.navigatorKey.currentState!.mounted) {
              middleware.onFailure(
                fGetItWallet.navigatorKey.currentState!.context,
                arguments,
              );
            }
            return;
          }
          FGetItLogger.logMiddlewareSuccess(middleware.runtimeType.toString());
        } else {
          FGetItLogger.logMiddlewareSkipped(middleware.runtimeType.toString());
        }
      }
      FGetItLogger.logEndDivider();
    }

    await fGetItWallet.initBinds(
      route: routeToSolve,
    );
    fGetItWallet.navigatorKey.currentState?.popAndPushNamed(
      routeToSolve.fullPath,
      arguments: arguments,
    );
    return;
  }

  @override
  void dispose() {
    _streamLoader.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.loaderBuilder?.call(_streamLoader.stream) ??
        const FlutterGetItLoader();
  }
}

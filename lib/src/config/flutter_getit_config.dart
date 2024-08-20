import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../debug/extension/flutter_get_it_extension.dart';
import '../dependency_injector/flutter_get_it_check_dependency.dart';
import '../middleware/flutter_get_it_middleware.dart';
import '../routers/flutter_get_it_route_params_extractor.dart';
import '../types/flutter_getit_typedefs.dart';

enum FlutterGetItContextType {
  main('APPLICATION'),
  navigator('NAVIGATOR'),
  ;

  final String key;
  const FlutterGetItContextType(this.key);
}

class FlutterGetIt extends StatefulWidget {
  const FlutterGetIt({
    super.key,
    this.builder,
    this.builderPath,
    this.bindings,
    this.middlewares,
    this.modules,
    this.pagesRouter,
    this.modulesRouter,
    this.loggerConfig,
  })  : contextType = FlutterGetItContextType.main,
        name = null,
        assert((builder == null) != (builderPath == null),
            'Please use either Builder or BuilderPath, not both.');

  const FlutterGetIt.navigator({
    super.key,
    this.builder,
    this.builderPath,
    this.bindings,
    this.middlewares,
    this.name,
    this.modules,
    this.modulesRouter,
    this.pagesRouter,
    this.loggerConfig,
  })  : contextType = FlutterGetItContextType.navigator,
        assert((builder == null) != (builderPath == null),
            'Please use either Builder or BuilderPath, not both.');

  /// [builder] The builder that will be used to wrap the MaterialApp or CupertinoApp.
  ///
  final ApplicationBuilder? builder;
  final ApplicationBuilderPath? builderPath;

  /// [bindings] The bindings that will be used in the main context.
  /// Normally used to register the bindings that will be used in the main context throughout the application.
  ///
  final FlutterGetItBindings? bindings;

  /// [middlewares] The middlewares that will be used in the main context.
  /// Normally used to register the middlewares that will be used in the main context throughout the application.
  ///
  /// The middlewares are used to intercept the creation of the [FlutterGetItPageRouter] and the [FlutterGetItModuleRouter].
  /// When you put a middleware in the main context, it will be used in all contexts, be careful with this.
  /// If you need to use a middleware only in a specific context,you can add the middleware in the [FlutterGetItPageRouter] and the [FlutterGetItModuleRouter].
  ///
  final List<FlutterGetItMiddleware>? middlewares;

  /// [name] The name of the context that will be used in the [FlutterGetIt.navigator].
  ///
  final String? name;

  /// [loggerConfig] The configuration that will be used in the logger.
  ///
  final FGetItLoggerConfig? loggerConfig;

  /// [modules] Specifies the list of modules in your system.
  ///
  final List<FlutterGetItModule>? modules;

  /// [pages] Define the pages that will serve as named routes based on [FlutterGetItPageRoute].
  ///
  final List<FlutterGetItPageRouter>? pagesRouter;
  final List<FlutterGetItModuleRouter>? modulesRouter;

  /// [contextType] The type of context that will be used in the [FlutterGetIt].
  final FlutterGetItContextType contextType;

  @override
  State<FlutterGetIt> createState() => _FlutterGetItState();
}

class _FlutterGetItState extends State<FlutterGetIt>
    with AutomaticKeepAliveClientMixin {
  Set<String> checkBinds = {};
  @override
  void initState() {
    _registerAndLoadDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //_loadMiddlewares();
      await _callAllReady();
    });
    super.initState();
  }

  void _registerAndLoadDependencies() {
    final getIt = GetIt.I;
    var FlutterGetIt(
      bindings: appBindings,
      :contextType,
      middlewares: appMiddlewares,
      name: appContextName,
      :loggerConfig,
    ) = widget;
    switch (contextType) {
      case FlutterGetItContextType.main:
        if (getIt.isRegistered<FlutterGetItContainerRegister>()) {
          throw Exception(
              'You can only have one instance of FlutterGetItContainerRegister.\nCheck if you are using the FlutterGetIt in the multiple locations, try FlutterGetIt.navigator and pass a "name" if necessary.');
        }
        final register = getIt.registerSingleton(
          FlutterGetItContainerRegister(),
        );
        final logRules = loggerConfig ?? FGetItLoggerConfig();
        if (appBindings?.bindings() != null) {
          checkBinds.addAll(FlutterGetItCheckDependency.checkOnDependencies(
              alreadyCheck: checkBinds,
              bindings: appBindings!.bindings().toList()));
        }
        getIt
          ..registerSingleton(FlutterGetItExtension(register: register))
          ..registerSingleton(logRules)
          ..registerSingleton(FGetItLogger(logRules));
        FGetItLogger.logCreatingContext(contextType.key);
        register
          ..register(
            contextType.key,
            appBindings?.bindings() ?? [],
            middleware: appMiddlewares ?? [],
          )
          ..load(contextType.key);

        break;
      case FlutterGetItContextType.navigator:
        if (!getIt.isRegistered<FlutterGetItContainerRegister>()) {
          throw Exception(
              'Are you trying to use the FlutterGetIt.navigator without the FlutterGetIt in the main context? Please add the FlutterGetIt in the main');
        }
        FGetItLogger.logCreatingContext(appContextName ?? contextType.key);
        final register = Injector.get<FlutterGetItContainerRegister>();
        if (register.isRegistered(contextType.key)) {
          throw Exception(
              'You can only have one instance of ${appContextName ?? contextType.key}.\nCheck if you are using the FlutterGetIt.navigator in the multiple locations, try pass a "name" to create a different context.');
        }
        if (appBindings?.bindings() != null) {
          checkBinds.addAll(FlutterGetItCheckDependency.checkOnDependencies(
              alreadyCheck: checkBinds, bindings: appBindings!.bindings()));
        }
        register
          ..register(
              appContextName ?? contextType.key, appBindings?.bindings() ?? [],
              middleware: appMiddlewares ?? [])
          ..load(appContextName ?? contextType.key);
        break;
    }
  }

  Map<String, WidgetBuilder> _routes() {
    final routesMap = <String, WidgetBuilder>{};
    final modules = widget.modules;
    final pages = widget.pagesRouter;
    final modulesRouter = widget.modulesRouter ?? [];

    if (modules != null) {
      for (var module in modules) {
        for (var page in module.pages) {
          routesMap.addAll(
            _recursivePage(
              module: module,
              page: page,
              lastModuleName: module.moduleRouteName,
              moduleRouter: switch (page) {
                FlutterGetItModuleRouter() => [page],
                _ => [],
              },
            ),
          );
        }
      }
    }

    if (pages != null) {
      // Adding the pages within the page module to avoid altering the core of modules in fgetit."
      final pagesModule = pages.map(
        (page) {
          assert(page is! FlutterGetItModuleRouter,
              'You cannot use the FlutterGetItModuleRouter in the pagesRouter, use the modulesRouter instead.');
          return FlutterGetItModuleRouter(
            name: '/',
            pages: [page],
          );
        },
      );
      modulesRouter.addAll(pagesModule);
    }

    if (modulesRouter.isNotEmpty) {
      for (var moduleRoute in modulesRouter) {
        final module = FlutterGetItModuleInternalForPage(
          binds: moduleRoute.bindings,
          moduleRouteName: moduleRoute.name,
          onDispose: moduleRoute.onDispose ?? (i) {},
          onInit: moduleRoute.onInit ?? (i) {},
          pages: moduleRoute.pages,
        );
        routesMap.addAll(
          _recursivePage(
            module: module,
            page: moduleRoute,
            lastModuleName: '/',
            moduleRouter: [moduleRoute],
          ),
        );
      }
    }

    // register routes for use in FlutterGetIt.navigator
    final getit = GetIt.I;
    if (!getit.isRegistered<Map<String, WidgetBuilder>>(
        instanceName: 'RoutesMap_${widget.contextType.key}')) {
      getit.registerSingleton(routesMap,
          instanceName: 'RoutesMap_${widget.contextType.key}');
    }

    return routesMap;
  }

  Map<String, WidgetBuilder> _recursivePage({
    String lastModuleName = '',
    required FlutterGetItModule module,
    required FlutterGetItPageRouter page,
    List<FlutterGetItModuleRouter> moduleRouter = const [],
  }) {
    final routesMap = <String, WidgetBuilder>{};
    if (lastModuleName != '/' && lastModuleName.endsWith('/')) {
      FGetItLogger.logErrorModuleShouldStartWithSlash(lastModuleName);
      lastModuleName = lastModuleName.replaceFirst(RegExp(r'/$'), '');
    }

    if (lastModuleName != '/' && !lastModuleName.startsWith('/')) {
      FGetItLogger.logErrorModuleShouldStartWithSlash(lastModuleName);
      lastModuleName = '/$lastModuleName';
    }

    var pageRouteName = page.name;
    if (!pageRouteName.startsWith(r'/')) {
      FGetItLogger.logErrorModuleShouldStartWithSlash(lastModuleName);
      pageRouteName = '/${page.name}';
    }

    var finalRoute = '$lastModuleName$pageRouteName';

    checkBinds.addAll(
      FlutterGetItCheckDependency.checkOnDependencies(
        alreadyCheck: checkBinds,
        bindings: module.bindings,
      ),
    );

    if (page is FlutterGetItModuleRouter) {
      if (page.pages.isNotEmpty) {
        for (final pageInternal in page.pages) {
          checkBinds.addAll(
            FlutterGetItCheckDependency.checkOnDependencies(
              alreadyCheck: checkBinds,
              bindings: pageInternal.bindings,
            ),
          );
          routesMap.addAll(
            _recursivePage(
              lastModuleName: finalRoute,
              module: module,
              page: pageInternal,
              moduleRouter: switch (pageInternal) {
                FlutterGetItModuleRouter() => [
                    ...moduleRouter,
                    pageInternal,
                  ],
                _ => moduleRouter,
              },
            ),
          );
        }
      }
    } else {
      routesMap[finalRoute.replaceAll(r'//', r'/')] = (BuildContext context) {
        final path = ModalRoute.of(context)!.settings.name!;
        final params =
            FlutterGetItRouteParamsExtractor(finalRoute, path).extract();
        return FlutterGetItPageModule(
          module: module,
          page: page,
          moduleRouter: moduleRouter,
          parameters: params,
        );
      };
    }

    return routesMap;
  }

  final _completer = Completer<void>();

  Future<void> _callAllReady() async {
    FGetItLogger.logWaitingAsyncByModule(widget.contextType.key);
    await GetIt.I.allReady();
    FGetItLogger.logWaitingAsyncByModuleCompleted(widget.contextType.key);
    setState(() {
      _completer.complete();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);

  //   return widget.builder(
  //     context,
  //     _routes(),
  //     _completer.isCompleted,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.builderPath != null) {
      return widget.builderPath!(
        context,
        _completer.isCompleted,
        _handleOnGenerateRoute(),
      );
    }
    return widget.builder!(
      context,
      _routes(),
      _completer.isCompleted,
    );
  }

  RouteFactory _handleOnGenerateRoute() {
    return (settings) {
      final name = settings.name;

      for (final route in _routes().keys) {
        final regExpPattern = routeToRegExp(route);
        if (regExpPattern.hasMatch(name!)) {
          final params =
              FlutterGetItRouteParamsExtractor(route, name).extract();
          final moduleRouter = _findModuleRouterByRoute(route);
          return MaterialPageRoute(
            builder: (context) => FlutterGetItPageModule(
              module: _findModuleByRoute(route),
              page: _findPageByRoute(route),
              moduleRouter: moduleRouter, // Preencher conforme necessário
              parameters: params,
            ),
            settings: settings,
          );
        }
      }
      return null; // Retorne null se nenhuma rota correspondente for encontrada
    };
  }

  List<FlutterGetItModuleRouter> _findModuleRouterByRoute(String route) {
    List<FlutterGetItModuleRouter> moduleRouters = [];

    for (final module in widget.modules ?? []) {
      for (final page in module.pages) {
        final fullPath =
            '${module.moduleRouteName}${page.name}'.replaceAll(r'//', r'/');
        final regExpPattern = routeToRegExp(fullPath);
        if (regExpPattern.hasMatch(route)) {
          moduleRouters.add(
            FlutterGetItModuleRouter(
              name: module.moduleRouteName,
              pages: module.pages,
              bindings: module.bindings,
              onInit: module.onInit,
              onDispose: module.onDispose,
            ),
          );
        }
      }
    }

    return moduleRouters;
  }

  RegExp routeToRegExp(String route) {
    return RegExp(
      '^' +
          route.replaceAllMapped(RegExp(r'(:\w+)'), (match) {
            return r'([^/]+)'; // Ajuste aqui para capturar qualquer coisa até a próxima /
          }) +
          r'$',
    );
  }

  FlutterGetItModule _findModuleByRoute(String route) {
    for (final module in widget.modules ?? []) {
      for (final page in module.pages) {
        final fullPath =
            '${module.moduleRouteName}${page.name}'.replaceAll(r'//', r'/');
        final regExpPattern = routeToRegExp(fullPath);
        if (regExpPattern.hasMatch(route)) {
          return module;
        }
      }
    }
    throw Exception('No module found for route: $route');
  }

  FlutterGetItPageRouter _findPageByRoute(String route) {
    for (final module in widget.modules ?? []) {
      for (final page in module.pages) {
        final fullPath =
            '${module.moduleRouteName}${page.name}'.replaceAll(r'//', r'/');
        final regExpPattern = routeToRegExp(fullPath);
        if (regExpPattern.hasMatch(route)) {
          return page;
        }
      }
    }
    throw Exception('No page found for route: $route');
  }

  @override
  bool get wantKeepAlive => true;
}

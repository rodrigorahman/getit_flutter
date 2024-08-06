import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
import '../debug/extension/flutter_get_it_extension.dart';
import '../middleware/flutter_get_it_middleware.dart';
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
    required this.builder,
    ApplicationBindings? bindings,
    List<FlutterGetItMiddleware>? middewares,
    this.modules,
    this.pages,
    this.loggerConfig,
  })  : contextType = FlutterGetItContextType.main,
        appBindings = bindings,
        appMiddlewares = middewares,
        appContextName = null;

  const FlutterGetIt.navigator({
    super.key,
    required this.builder,
    NavigatorBindings? bindings,
    List<FlutterGetItMiddleware>? middewares,
    String? navigatorName,
    this.modules,
    this.pages,
    this.loggerConfig,
  })  : contextType = FlutterGetItContextType.navigator,
        appBindings = bindings,
        appMiddlewares = middewares,
        appContextName = navigatorName;

  final ApplicationBuilder builder;
  final FlutterGetItBindings? appBindings;
  final List<FlutterGetItMiddleware>? appMiddlewares;
  final String? appContextName;
  final FGetItLoggerConfig? loggerConfig;

  /// [modules] Specifies the list of modules in your system.
  final List<FlutterGetItModule>? modules;

  /// [pages] Define the pages that will serve as named routes based on [FlutterGetItPageRoute].
  final List<FlutterGetItModuleRouter>? pages;

  final FlutterGetItContextType contextType;

  @override
  State<FlutterGetIt> createState() => _FlutterGetItState();
}

class _FlutterGetItState extends State<FlutterGetIt>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    _registerAndLoadDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_loadMiddlewares();
      _callAllReady();
    });
    super.initState();
  }

  void _registerAndLoadDependencies() {
    final getIt = GetIt.I;
    var FlutterGetIt(
      :appBindings,
      :contextType,
      :appMiddlewares,
      :appContextName,
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

        getIt
          ..registerSingleton(FlutterGetItExtension(register: register))
          ..registerSingleton(logRules)
          ..registerSingleton(FGetItLogger(logRules))
          ..registerLazySingleton(FlutterGetItContext.new);
        FGetItLogger.logCreatingContext(contextType.key);
        register
          ..register(
            contextType.key,
            appBindings?.bindings() ?? [],
            middleware: appMiddlewares ?? [],
          )
          ..load(contextType.key)
          ..loadPermanent();

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
        register
          ..register(
              appContextName ?? contextType.key, appBindings?.bindings() ?? [],
              middleware: appMiddlewares ?? [])
          ..load(appContextName ?? contextType.key)
          ..loadPermanent();
        break;
    }
  }

  Map<String, WidgetBuilder> _routes() {
    final routesMap = <String, WidgetBuilder>{};
    final modules = widget.modules;
    final pages = widget.pages;

    if (modules != null) {
      for (var module in modules) {
        for (var page in module.pages) {
          routesMap.addAll(
            recursivePage(
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
      for (var page in pages) {
        final module = FlutterGetItModuleInternalForPage(
          binds: page.bindings,
          moduleRouteName: page.name,
          onDispose: page.onDispose ?? (i) {},
          onInit: page.onInit ?? (i) {},
          pages: page.pages,
        );
        routesMap.addAll(
          recursivePage(
            module: module,
            page: page,
            lastModuleName: '/',
            moduleRouter: [page],
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

  Map<String, WidgetBuilder> recursivePage({
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

    final isModuleRouter = page is FlutterGetItModuleRouter;

    if (page.pages.isNotEmpty) {
      for (final pageInternal in page.pages) {
        routesMap.addAll(
          recursivePage(
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

    if (!isModuleRouter) {
      routesMap[finalRoute.replaceAll(r'//', r'/')] = (_) {
        return FlutterGetItPageModule(
          module: module,
          page: page,
          moduleRouter: moduleRouter,
        );
      };
    }
    return routesMap;
  }

  final _completer = Completer<void>();

  Future<void> _callAllReady() async {
    await Injector.allReady();
    setState(() {
      _completer.complete();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.builder(
      context,
      _routes(),
      _completer.isCompleted,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

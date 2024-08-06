import 'dart:async';

import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../middleware/flutter_get_it_middleware.dart';

abstract class FlutterGetItModule {
  List<Bind> get bindings => [];
  List<FlutterGetItPageRouter> get pages;
  final List<FlutterGetItMiddleware> middlewares = [];
  String get moduleRouteName;
  void onDispose(Injector i);
  void onInit(Injector i);
}

final class FlutterGetItModuleInternalForPage extends FlutterGetItModule {
  final List<Bind<Object>> _binds;
  final String _moduleRouteName;
  final void Function(Injector i) _onDispose;
  final void Function(Injector i) _onInit;
  final List<FlutterGetItPageRouter> _pages;

  FlutterGetItModuleInternalForPage({
    required List<Bind<Object>> binds,
    required String moduleRouteName,
    required void Function(Injector i) onDispose,
    required void Function(Injector i) onInit,
    required List<FlutterGetItPageRouter> pages,
  })  : _binds = binds,
        _moduleRouteName = moduleRouteName,
        _onDispose = onDispose,
        _onInit = onInit,
        _pages = pages;

  @override
  List<Bind<Object>> get bindings => _binds;

  @override
  String get moduleRouteName => _moduleRouteName;

  @override
  void onDispose(Injector i) => _onDispose(i);

  @override
  void onInit(Injector i) => _onInit(i);

  @override
  List<FlutterGetItPageRouter> get pages => _pages;
}

class FlutterGetItPageModule extends StatefulWidget {
  const FlutterGetItPageModule({
    super.key,
    required this.module,
    required this.page,
    required this.moduleRouter,
  });

  final FlutterGetItModule module;
  final FlutterGetItPageRouter page;
  final List<FlutterGetItModuleRouter> moduleRouter;

  @override
  State<FlutterGetItPageModule> createState() => _FlutterGetItPageModuleState();
}

class _FlutterGetItPageModuleState extends State<FlutterGetItPageModule> {
  late final String id;
  late final String moduleName;
  late final FlutterGetItContainerRegister containerRegister;
  List<String> routerModule = [];
  Widget? onExecute;

  @override
  void initState() {
    var initExecution = <Function>[];
    final FlutterGetItPageModule(
      module: (FlutterGetItModule(
        :moduleRouteName,
        bindings: bindingsModule,
        middlewares: middlewaresModule
      )),
      :page,
    ) = widget;
    containerRegister = Injector.get<FlutterGetItContainerRegister>();
    var middlewareExecution = <FlutterGetItMiddleware>[];

    moduleName = '$moduleRouteName-module';
    final allSubModulesNames = widget.moduleRouter.map((e) => e.name).toList();
    id = '$moduleRouteName-module${allSubModulesNames.join()}${page.name}';
    final moduleAlreadyRegistered = containerRegister.isRegistered(moduleName);
    if (!moduleAlreadyRegistered) {
      FGetItLogger.logEnterOnModule(moduleName);
      initExecution.add(() => widget.module.onInit(Injector()));
    }
    middlewareExecution.addAll(containerRegister.middlewares('APPLICATION'));
    //Module Binds
    containerRegister
      ..register(
        moduleName,
        bindingsModule,
        middleware: middlewaresModule,
      )
      ..load(moduleName)
      ..middlewares(moduleRouteName).forEach(middlewareExecution.add);

    if (widget.moduleRouter.isNotEmpty) {
      for (var moduleRouter in widget.moduleRouter) {
        if (moduleRouter.name != moduleRouteName) {
          final indexRouter = widget.moduleRouter.indexOf(moduleRouter);
          final lastNames = widget.moduleRouter
              .sublist(0, indexRouter)
              .map((e) => e.name)
              .toList();
          final routeM = '$moduleName${lastNames.join()}${moduleRouter.name}';
          routerModule.add(routeM);

          final moduleAlreadyRegisteredInternal =
              containerRegister.isRegistered(routeM);
          if (!moduleAlreadyRegisteredInternal) {
            FGetItLogger.logEnterOnSubModule(routeM);
            initExecution.add(() => moduleRouter.onInit?.call(Injector()));
          }
          containerRegister
            ..register(
              routeM,
              moduleRouter.bindings,
              middleware: moduleRouter.middlewares,
            )
            ..load(
              routeM,
            )
            ..middlewares(routeM).forEach(middlewareExecution.add);
        }
      }
    }

    //Route Binds
    containerRegister
      ..register(
        id,
        page.bindings,
        middleware: page.middlewares,
      )
      ..load(id);

    middlewareExecution.addAll(page.middlewares);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modularRoute = ModalRoute.of(context);

      await _callAllReady();
      final canLoad = await _executeMiddlewares(
        middlewareExecution,
        route: modularRoute?.settings,
      );
      if (canLoad == MiddlewareResult.complete) {
        for (var initExecute in initExecution) {
          initExecute();
        }
        setState(() {
          _completer.complete();
        });
      }
    });

    super.initState();
  }

  final _completer = Completer<void>();

  Future<void> _callAllReady() async {
    await Injector.allReady();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page.page(
      context,
      _completer.isCompleted,
      onExecute,
    );
  }

  @override
  void dispose() {
    //Remove counter on context
    containerRegister.decrementListener(moduleName);
    containerRegister.decrementListener(id);

    for (var route in routerModule.reversed) {
      containerRegister.decrementListener(route);

      final anyCoreDependents = containerRegister.anyCoreDependents(route);
      if (!anyCoreDependents) {
        containerRegister.unRegister(route);
        final element =
            widget.moduleRouter.cast<FlutterGetItModuleRouter?>().firstWhere(
                  (element) =>
                      element?.name.endsWith(route.split('/').last) ?? false,
                  orElse: () => null,
                );
        if (element != null) {
          element.onDispose?.call(
            Injector(),
          );
        }
      }
    }

    final anyCoreDependents = containerRegister.anyCoreDependents(moduleName);

    containerRegister.unRegister(id);

    if (!anyCoreDependents) {
      containerRegister.unRegister(moduleName);
      FGetItLogger.logDisposeModule(widget.module.moduleRouteName);
      widget.module.onDispose(Injector());
    }
    super.dispose();
  }

  Future<MiddlewareResult> _executeMiddlewares(
      List<FlutterGetItMiddleware> middlewareExecution,
      {RouteSettings? route}) async {
    final flutterGetItMiddlewareContext =
        FlutterGetItMiddlewareContext(context);
    for (var middleware in middlewareExecution) {
      switch (middleware) {
        case FlutterGetItSyncMiddleware():
          final resultMiddleware = middleware.execute(route);
          if (resultMiddleware != MiddlewareResult.next) {
            middleware.onFail(
                route, flutterGetItMiddlewareContext, resultMiddleware);
            return resultMiddleware;
          }
          break;

        case FlutterGetItAsyncMiddleware():
          setState(() {
            onExecute = middleware.onExecute;
          });

          final resultMiddleware = await middleware.execute(route);
          if (resultMiddleware == MiddlewareResult.failure) {
            setState(() {
              onExecute = null;
            });
            middleware.onFail(
                route, flutterGetItMiddlewareContext, resultMiddleware);
            return resultMiddleware;
          }
          setState(() {
            onExecute = null;
          });

          break;
      }
    }
    return MiddlewareResult.complete;
  }
}

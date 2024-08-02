import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
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
  bool isExecuting = false;

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
    final flutterGetItContext = Injector.get<FlutterGetItContext>();
    containerRegister = Injector.get<FlutterGetItContainerRegister>();
    var middlewareExecution = <FlutterGetItMiddleware>[];

    moduleName = '$moduleRouteName-module';
    id = '$moduleRouteName-module${page.name}';
    final moduleAlreadyRegistered =
        flutterGetItContext.isRegistered(moduleName);
    if (!moduleAlreadyRegistered) {
      FGetItLogger.logEnterOnModule(moduleName);
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

    if (!moduleAlreadyRegistered) {
      initExecution.add(() => widget.module.onInit(Injector()));
    }

    if (widget.moduleRouter.isNotEmpty) {
      for (var moduleRouter in widget.moduleRouter) {
        if (moduleRouter.name != moduleRouteName) {
          final routeM = '$moduleName${moduleRouter.name}';
          routerModule.add(routeM);

          final moduleAlreadyRegisteredInternal =
              flutterGetItContext.isRegistered(routeM);
          if (!moduleAlreadyRegisteredInternal) {
            FGetItLogger.logEnterOnSubModule(routeM);
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

          if (!moduleAlreadyRegisteredInternal) {
            initExecution.add(() => moduleRouter.onInit?.call(Injector()));
          }
          flutterGetItContext.registerId(
            routeM,
          );
        }
      }
    }

    //Register Module
    flutterGetItContext.registerId(
      id,
    );

    //Route Binds
    containerRegister
      ..register(
        id,
        page.bindings,
        middleware: page.middlewares,
      )
      ..load(id);

    middlewareExecution.addAll(page.middlewares);
    //appbinding
    //rotapai
    //subrota
    //page
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final canLoad = await _executeMiddlewares(middlewareExecution,
          route: ModalRoute.of(context)?.settings);
      if (canLoad == MiddlewareResult.complete) {
        for (var initExecute in initExecution) {
          initExecute();
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isExecuting)
        ? onExecute ?? const SizedBox.shrink()
        : widget.page.page(context);
  }

  @override
  void dispose() {
    final flutterGetItContext = Injector.get<FlutterGetItContext>();

    //Remove counter on context
    flutterGetItContext.reduceId(moduleName);
    flutterGetItContext.reduceId(id);

    for (var route in routerModule) {
      flutterGetItContext.reduceId(route);

      final canRemoveModuleInternal =
          flutterGetItContext.canUnregisterCoreModule(route);
      if (canRemoveModuleInternal) {
        containerRegister.unRegister(route);
        flutterGetItContext.deleteId(route);
        FGetItLogger.logDisposeSubModule(route);
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

    final canRemoveModuleCore =
        flutterGetItContext.canUnregisterCoreModule(moduleName);

    containerRegister.unRegister(id);
    flutterGetItContext.deleteId(id);

    if (canRemoveModuleCore) {
      containerRegister.unRegister(moduleName);
      flutterGetItContext.deleteId(moduleName);
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
            middleware.onFail(route, flutterGetItMiddlewareContext, 'Falha',
                resultMiddleware);
            return resultMiddleware;
          }
          break;

        case FlutterGetItAsyncMiddleware():
          setState(() {
            onExecute = middleware.onExcute;
            isExecuting = true;
          });

          final resultMiddleware = await middleware.execute(route);
          if (resultMiddleware == MiddlewareResult.failure) {
            setState(() {
              isExecuting = false;
              onExecute = null;
            });
            middleware.onFail(route, flutterGetItMiddlewareContext, 'Falha',
                resultMiddleware);
            return resultMiddleware;
          }
          setState(() {
            isExecuting = false;
            onExecute = null;
          });

          break;
      }
    }
    return MiddlewareResult.complete;
  }
}

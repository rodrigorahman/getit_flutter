import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';

abstract class FlutterGetItModule {
  List<Bind> get bindings => [];
  List<FlutterGetItPageRouter> get pages;
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

  @override
  void initState() {
    final FlutterGetItPageModule(
      module: (FlutterGetItModule(:moduleRouteName, bindings: bindingsModule)),
      :page,
    ) = widget;
    final flutterGetItContext = Injector.get<FlutterGetItContext>();
    containerRegister = Injector.get<FlutterGetItContainerRegister>();
    moduleName = '$moduleRouteName-module';
    id = '$moduleRouteName-module${page.name}';
    final moduleAlreadyRegistered =
        flutterGetItContext.isRegistered(moduleName);

    if (!moduleAlreadyRegistered) {
      DebugMode.fGetItLog(
          '🛣️$yellowColor Entering Module: $moduleName - calling $yellowColor"onInit()"');
    }

    //Module Binds
    containerRegister
      ..register(
        moduleName,
        bindingsModule,
      )
      ..load(moduleName);

    if (!moduleAlreadyRegistered) {
      widget.module.onInit(Injector());
    }

    if (widget.moduleRouter.isNotEmpty) {
      for (var moduleRouter in widget.moduleRouter) {
        if (moduleRouter.name != moduleRouteName) {
          final routeM = '$moduleName${moduleRouter.name}';
          routerModule.add(routeM);

          final moduleAlreadyRegisteredInternal =
              flutterGetItContext.isRegistered(routeM);
          if (!moduleAlreadyRegisteredInternal) {
            DebugMode.fGetItLog(
                '🛣️$yellowColor Entering Sub-Module: $routeM - calling $yellowColor"onInit()"');
          }

          containerRegister
            ..register(
              routeM,
              moduleRouter.bindings,
            )
            ..load(
              routeM,
            );
          if (!moduleAlreadyRegisteredInternal) {
            moduleRouter.onInit?.call(Injector());
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
      )
      ..load(id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page.page(context);
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
        DebugMode.fGetItLog(
            '🛣️$yellowColor Exiting Sub-Module: $route - calling "onDispose()"');
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
      DebugMode.fGetItLog(
          '🛣️$yellowColor Exiting Module: ${widget.module.moduleRouteName} - calling "onDispose()"');
      widget.module.onDispose(Injector());
    }
    super.dispose();
  }
}

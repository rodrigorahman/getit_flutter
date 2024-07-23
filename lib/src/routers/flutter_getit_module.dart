import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';

abstract class FlutterGetItModule {
  List<Bind> get bindings => [];
  List<FlutterGetItPageRouter> get pages;
  String get moduleRouteName;
  void onClose(Injector i);
  void onInit(Injector i);
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
    /*  final moduleAlreadyRegistered =
        flutterGetItContext.isRegistered(moduleRouteName); */

    //Module Binds
    containerRegister
      ..register(
        moduleName,
        bindingsModule,
      )
      ..load(moduleName);

    if (widget.moduleRouter.isNotEmpty) {
      for (var moduleRouter in widget.moduleRouter) {
        final routeM = '$moduleName${moduleRouter.name}';
        routerModule.add(routeM);

        containerRegister
          ..register(
            routeM,
            moduleRouter.bindings,
          )
          ..load(
            routeM,
          );
        flutterGetItContext.registerId(
          routeM,
        );
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
      }
    }

    final canRemoveModuleCore =
        flutterGetItContext.canUnregisterCoreModule(moduleName);

    if (canRemoveModuleCore) {
      containerRegister.unRegister(moduleName);
      flutterGetItContext.deleteId(moduleName);
    }
    containerRegister.unRegister(id);
    flutterGetItContext.deleteId(id);

    if (canRemoveModuleCore) {
      DebugMode.fGetItLog(
          '🛣️$yellowColor Exiting Module: ${widget.module.moduleRouteName} - calling $yellowColor"onClose()"');
      widget.module.onClose(Injector());
    }
    super.dispose();
  }
}

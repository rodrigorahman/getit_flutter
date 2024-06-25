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
  });

  final FlutterGetItModule module;
  final FlutterGetItPageRouter page;

  @override
  State<FlutterGetItPageModule> createState() => _FlutterGetItPageModuleState();
}

class _FlutterGetItPageModuleState extends State<FlutterGetItPageModule> {
  late final String id;
  late final String moduleName;
  late final FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    super.initState();
    final FlutterGetItPageModule(
      module: (FlutterGetItModule(:moduleRouteName, bindings: bindingsModule)),
      :page,
    ) = widget;
    final flutterGetItContext = Injector.get<FlutterGetItContext>();
    containerRegister = Injector.get<FlutterGetItContainerRegister>();
    moduleName = moduleRouteName;
    id = '$moduleRouteName-module${page.name}';
    final moduleAlreadyRegistered =
        flutterGetItContext.isRegistered(moduleRouteName);

    if (!moduleAlreadyRegistered) {
      containerRegister
        ..register(
          '$moduleRouteName-module',
          bindingsModule,
        )
        ..load('$moduleRouteName-module');
      flutterGetItContext.registerId(
        moduleRouteName,
        hashCode,
      );
    }

    containerRegister
      ..register(
        id,
        page.bindings,
      )
      ..load(id);
  }

  @override
  Widget build(BuildContext context) {
    return widget.page.page(context);
  }

  @override
  void dispose() {
    final flutterGetItContext = Injector.get<FlutterGetItContext>();

    if (flutterGetItContext.canUnregister(moduleName, hashCode)) {
      DebugMode.fGetItLog(
          '🛣️$yellowColor Exiting Module: ${widget.module.moduleRouteName} - $blueColor calling $yellowColor"onClose()"');
      widget.module.onClose(Injector());
      containerRegister.unRegister('$moduleName-module');
    }
    containerRegister.unRegister(id);
    super.dispose();
  }
}

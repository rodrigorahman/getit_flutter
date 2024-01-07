import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_container_register.dart';
import '../core/flutter_getit_context.dart';

abstract class FlutterGetItModule {
  List<Bind> get bindings => [];
  Map<String, WidgetBuilder> get pages;
  String get moduleRouteName;
}

class FlutterGetItPageModule extends StatefulWidget {
  const FlutterGetItPageModule(
      {super.key, required this.module, required this.page});

  final FlutterGetItModule module;
  final WidgetBuilder page;

  @override
  State<FlutterGetItPageModule> createState() => _FlutterGetItPageModuleState();
}

class _FlutterGetItPageModuleState extends State<FlutterGetItPageModule> {
  late final String id;
  late FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    final FlutterGetItPageModule(
      module: (FlutterGetItModule(:moduleRouteName, :bindings)),
    ) = widget;
    id = moduleRouteName;
    final injector = Injector();
    containerRegister = injector<FlutterGetItContainerRegister>()
      ..register(id, bindings)
      ..load(id);

    final flutterGetItContext = injector<FlutterGetItContext>();
    flutterGetItContext.registerId(moduleRouteName);

    super.initState();
  }

  @override
  void dispose() {
    final flutterGetItContext = Injector()<FlutterGetItContext>();
    if (!flutterGetItContext.isSameIdLoad(id)) {
      containerRegister.unRegister(id);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page(context);
  }
}

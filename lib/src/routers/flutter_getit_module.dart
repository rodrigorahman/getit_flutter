import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';

abstract class FlutterGetItModule {
  List<Bind> get bindings => [];
  Map<String, WidgetBuilder> get pages;
  String get moduleRouteName;
}

class FlutterGetItPageModule extends StatefulWidget {
  const FlutterGetItPageModule({
    super.key,
    required this.module,
    required this.page,
  });

  final FlutterGetItModule module;
  final WidgetBuilder page;

  @override
  State<FlutterGetItPageModule> createState() => _FlutterGetItPageModuleState();
}

class _FlutterGetItPageModuleState extends State<FlutterGetItPageModule> {
  late final String id;
  late final FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    super.initState();
    final FlutterGetItPageModule(
      module: (FlutterGetItModule(:moduleRouteName, :bindings)),
    ) = widget;
    id = moduleRouteName;
    containerRegister = Injector.get<FlutterGetItContainerRegister>()
      ..register('$id-module', bindings,)
      ..load('$id-module');

    Injector.get<FlutterGetItContext>().registerId(moduleRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return widget.page(context);
  }

  @override
  void dispose() {
    final flutterGetItContext = Injector.get<FlutterGetItContext>();
    if (!flutterGetItContext.isSameIdLoad(id)) {
      containerRegister.unRegister('$id-module');
    }
    super.dispose();
  }
}

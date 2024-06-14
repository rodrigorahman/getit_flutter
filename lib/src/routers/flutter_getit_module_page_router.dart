import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

abstract class FlutterGetItModulePageRouter extends StatefulWidget {
  List<Bind> get bindings => [];
  WidgetBuilder get view;

  const FlutterGetItModulePageRouter({super.key});

  @override
  State<FlutterGetItModulePageRouter> createState() =>
      _FlutterGetItModulePageRouterState();
}

class _FlutterGetItModulePageRouterState
    extends State<FlutterGetItModulePageRouter> {
  late final String routeId;
  late final FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    super.initState();
    final navObserver = Injector.get<FlutterGetItNavigatorObserver>();
    routeId = navObserver.currentRoute ?? hashCode.toString();

    containerRegister = Injector.get<FlutterGetItContainerRegister>()
      ..register(routeId, widget.bindings)
      ..load(routeId);
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }

  @override
  void dispose() {
    containerRegister.unRegister(routeId);
    super.dispose();
  }
}

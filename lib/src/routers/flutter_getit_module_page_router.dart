import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_container_register.dart';
import '../core/navigator/flutter_getit_navigator_observer.dart';

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
  late FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    final injector = Injector();
    final navObserver = injector<FlutterGetItNavigatorObserver>();
    routeId = navObserver.currentRoute ?? hashCode.toString();
    containerRegister = injector<FlutterGetItContainerRegister>()
      ..register(routeId, widget.bindings)
      ..load(routeId);

    super.initState();
  }

  @override
  void dispose() {
    containerRegister.unRegister(routeId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }
}

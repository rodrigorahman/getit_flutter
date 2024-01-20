import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_container_register.dart';
import '../core/flutter_getit_context.dart';
import 'flutter_getit_page_router_interface.dart';

abstract class FlutterGetItPageRouter extends StatefulWidget
    implements FlutterGetItPageRouterInterface {
  const FlutterGetItPageRouter({super.key});

  Injector get injector => Injector();
  Injector get i => injector;

  @override
  State<FlutterGetItPageRouter> createState() => _FlutterGetItPageRouterState();
}

class _FlutterGetItPageRouterState extends State<FlutterGetItPageRouter> {
  late final String routeId;
  late FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    routeId = widget.routeName;
    containerRegister = Injector.get<FlutterGetItContainerRegister>()
      ..register(routeId, widget.bindings)
      ..load(routeId);

    final flutterGetItContext = Injector.get<FlutterGetItContext>();
    flutterGetItContext.registerId(routeId);

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

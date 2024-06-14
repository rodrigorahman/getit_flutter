import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
import 'flutter_getit_page_router_interface.dart';

abstract class FlutterGetItPageRouter extends StatefulWidget
    implements FlutterGetItPageRouterInterface {
  const FlutterGetItPageRouter({super.key});

  @override
  State<FlutterGetItPageRouter> createState() => _FlutterGetItPageRouterState();
}

class _FlutterGetItPageRouterState extends State<FlutterGetItPageRouter> {
  late final String routeId;
  late final FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    super.initState();
    routeId = widget.routeName;
    containerRegister = Injector.get<FlutterGetItContainerRegister>()
      ..register(
        routeId,
        widget.bindings,
      )
      ..load(routeId);

    Injector.get<FlutterGetItContext>().registerId(routeId);
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }

  @override
  void dispose() async {
    await containerRegister.unRegister(routeId);
    super.dispose();
  }
}

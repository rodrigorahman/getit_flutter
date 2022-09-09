import 'package:flutter/material.dart';

import 'bind.dart';

abstract class GetItPageRoute extends StatefulWidget {
  List<Bind> get bindings => [];
  WidgetBuilder get view;

  const GetItPageRoute({super.key});

  @override
  State<GetItPageRoute> createState() => _GetItPageRouteState();
}

class _GetItPageRouteState extends State<GetItPageRoute> {
  List<Bind> bindings = [];

  @override
  void initState() {
    super.initState();
    bindings.addAll(widget.bindings);
  }

  @override
  void dispose() {
    for (var bind in bindings) {
      // GetIt.I.unregister(instance: bind.instanceRegister);
      bind.unRegister();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }
}

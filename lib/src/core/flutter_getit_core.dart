import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

abstract class FlutterGetitCore extends StatefulWidget {
  List<Bind> get injections => [];
  WidgetBuilder get view;

  const FlutterGetitCore({super.key});

  @override
  State<FlutterGetitCore> createState() => _FlutterGetitCoreState();
}

class _FlutterGetitCoreState extends State<FlutterGetitCore> {
  List<Bind> bindings = [];

  @override
  void initState() {
    super.initState();
    bindings.addAll(widget.injections);
  }

  void _unRegisterAllBindings() {
    for (var bind in bindings) {
      bind.unRegister();
    }
  }

  @override
  void dispose() {
    _unRegisterAllBindings();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }

  @override
  void reassemble() {
    // _unRegisterAllBindings();
    // widget.injections;
    super.reassemble();
  }
}

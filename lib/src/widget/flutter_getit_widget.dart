import 'package:flutter/material.dart';

import '../core/flutter_getit_container_register.dart';
import '../dependency_injector/binds/bind.dart';
import '../dependency_injector/injector.dart';

abstract class FlutterGetItWidget extends StatefulWidget {
  const FlutterGetItWidget(ValueKey<String> key) : super(key: key);

  /// Getter for declaring bindings that will be initialized
  /// and discarded upon view initialization and disposal
  List<Bind> get bindings => [];

  /// Getter to inform which Page should be re-rendered upon loading
  WidgetBuilder get widget;

  @override
  State<FlutterGetItWidget> createState() => _FlutterGetItWidgetState();
}

class _FlutterGetItWidgetState extends State<FlutterGetItWidget> {
  late final String id;
  late FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    id = widget.key.toString();
    containerRegister = Injector().call<FlutterGetItContainerRegister>()
      ..register(id, widget.bindings, withTag: true)
      ..load(id);

    super.initState();
  }

  @override
  void dispose() {
    containerRegister.unRegister(id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.widget(context);
  }
}

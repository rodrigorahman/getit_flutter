import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

class FlutterGetItWidget extends StatefulWidget {
  const FlutterGetItWidget({
    super.key,
    this.name = '',
    required this.builder,
    this.binds = const [],
    this.onDispose,
    this.onInit,
  });

  /// The name of the widget
  ///
  final String name;

  /// The widget builder
  ///
  final WidgetBuilder builder;

  /// The binds of the widget
  ///
  final List<Bind> binds;

  /// The onDispose of the widget
  ///
  final void Function()? onDispose;

  /// The onInit of the widget
  ///
  final void Function()? onInit;

  @override
  State<FlutterGetItWidget> createState() => _FlutterGetItWidgetState();
}

class _FlutterGetItWidgetState extends State<FlutterGetItWidget> {
  late final String id;
  late final FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    super.initState();
    final FlutterGetItWidget(
      :name,
      :binds,
    ) = widget;
    containerRegister = Injector.get<FlutterGetItContainerRegister>();

    id = '/WIDGET-${name.isEmpty ? widget.hashCode : name}';

    final moduleAlreadyRegistered = containerRegister.isRegistered(id);

    if (moduleAlreadyRegistered) {
      //throw Exception('Widget $id already registered');
    }

    containerRegister
      ..register(
        id,
        binds,
      )
      ..load(id);

    if (!moduleAlreadyRegistered) {
      FGetItLogger.logEnterOnWidget(id);
      widget.onInit?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void dispose() {
    containerRegister.decrementListener(id);
    FGetItLogger.logDisposeWidget(
      id,
    );
    widget.onDispose?.call();
    containerRegister.unRegister(id);
    super.dispose();
  }
}

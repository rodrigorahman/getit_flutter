import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

class FlutterGetItWidget extends StatefulWidget {
  const FlutterGetItWidget({
    super.key,
    required this.name,
    required this.builder,
    this.binds = const [],
    this.onDispose,
    this.onInit,
  });

  final String name;
  final WidgetBuilder builder;
  final List<Bind> binds;
  final void Function()? onDispose;
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
    //Utilizado a hashCode para garantir que o id seja único, podendo ser utilizado em mais de um lugar
    id = '/WIDGET-$name';

    final moduleAlreadyRegistered = containerRegister.isRegistered(id);

    if (moduleAlreadyRegistered) {
      throw Exception('Widget $id already registered');
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

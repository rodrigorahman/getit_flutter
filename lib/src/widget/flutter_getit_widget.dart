import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';

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
  late final FlutterGetItContext fGetItContext;

  @override
  void initState() {
    super.initState();
    final FlutterGetItWidget(
      :name,
      :binds,
    ) = widget;
    containerRegister = Injector.get<FlutterGetItContainerRegister>();
    fGetItContext = Injector.get<FlutterGetItContext>();
    //Utilizado a hashCode para garantir que o id seja único, podendo ser utilizado em mais de um lugar
    id = '/WIDGET-$name';

    final moduleAlreadyRegistered = fGetItContext.isRegistered(id);

    if (moduleAlreadyRegistered) {
      throw Exception('Widget $id already registered');
    }

    containerRegister
      ..register(
        id,
        binds,
      )
      ..load(id)
      ..loadPermanent();

    if (!moduleAlreadyRegistered) {
      FGetItLogger.logEnterOnWidget(id);
      widget.onInit?.call();
    }
    fGetItContext.registerId(
      id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void dispose() {
    fGetItContext.reduceId(id);
    FGetItLogger.logDisposeWidget(
      id,
    );
    widget.onDispose?.call();
    containerRegister.unRegister(id);
    fGetItContext.deleteId(id);
    super.dispose();
  }
}

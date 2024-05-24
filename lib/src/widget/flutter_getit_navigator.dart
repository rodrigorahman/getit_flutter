import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

class FlutterGetItNavigator extends StatefulWidget {
  final Widget Function(BuildContext context,
      Widget? Function(RouteSettings routeSettings) onGenerateRoute) builder;

  const FlutterGetItNavigator({
    super.key,
    required this.builder,
    this.bindings = const <Bind>[],
    this.modules = const <FlutterGetItModule>[],
  });

  /// Getter for declaring bindings that will be initialized
  /// and discarded upon view initialization and disposal
  final List<Bind> bindings;
  final List<FlutterGetItModule> modules;

  @override
  State<FlutterGetItNavigator> createState() => _FlutterGetItNavigatorState();
}

class _FlutterGetItNavigatorState extends State<FlutterGetItNavigator> {
  late final String id;
  late FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    id = widget.key.toString();
    containerRegister = Injector.get<FlutterGetItContainerRegister>()
      ..register(id, widget.bindings, withTag: true)
      ..load(id);

    super.initState();
  }

  Widget? onGenerateRoute(RouteSettings settings) {
    final nameSplinted = settings.name?.split('/')?..removeAt(0);
    final possibleModuleName = nameSplinted?.first;
    final possibleModulePath = nameSplinted?.last;

    final module = widget.modules.cast<FlutterGetItModule?>().firstWhere(
      (element) {
        return (element?.moduleRouteName == '/$possibleModuleName') &&
            (element?.pages.containsKey('/$possibleModulePath') ?? false);
      },
      orElse: () => null,
    );
    switch (module) {
      case null:
        if (DebugMode.isEnable) {
          debugPrint('🚨$redColor Route not found: ${settings.name}');
        }
        return null;
      case _:
        try {
          Injector.get<FlutterGetItContainerRegister>()
              .load('/$possibleModuleName-module');
        } catch (e) {
          Injector.get<FlutterGetItContainerRegister>()
            ..register('/$possibleModuleName-module', module.bindings)
            ..load('/$possibleModuleName-module');
        }
        return module.pages['/$possibleModulePath']!.call(context);
    }
  }

  @override
  void dispose() {
    containerRegister.unRegister(id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, onGenerateRoute);
  }
}

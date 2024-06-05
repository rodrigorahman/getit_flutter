import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/navigator/flutter_getit_navigator_observer_internal.dart';
import '../routers/flutter_getit_module.dart';

class FlutterGetItNavigator extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    Widget? Function(RouteSettings routeSettings) onGenerateRoute,
    FlutterGetItNavigatorObserverInternal observer,
  ) builder;

  const FlutterGetItNavigator({
    super.key,
    required this.builder,
    this.routes = const <String, WidgetBuilder>{},
    this.modules = const <FlutterGetItModule>[],
  });

  /// Getter for declaring bindings that will be initialized
  /// and discarded upon view initialization and disposal
  final Map<String, WidgetBuilder> routes;
  final List<FlutterGetItModule> modules;

  @override
  State<FlutterGetItNavigator> createState() => _FlutterGetItNavigatorState();
}

class _FlutterGetItNavigatorState extends State<FlutterGetItNavigator> {
  final id = 'FGETITNAVIGATOR';
  late FlutterGetItContainerRegister containerRegister;
  late final FlutterGetItNavigatorObserverInternal observer;

  @override
  void initState() {
    containerRegister = Injector.get<FlutterGetItContainerRegister>();
    observer = FlutterGetItNavigatorObserverInternal()..init();
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
        switch (widget.routes.containsKey(settings.name)) {
          case true:
            return widget.routes[settings.name]!(context);
          case false:
            DebugMode.fGetItLog(
                '🚨$redColor Route not found: ${settings.name}');
            return null;
        }

      case _:
        return FlutterGetItPageModule(
          module: module,
          page: module.pages['/$possibleModulePath']!,
        );
    }
  }

  @override
  void dispose() {
    containerRegister.unRegister(id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, onGenerateRoute, observer);
  }
}

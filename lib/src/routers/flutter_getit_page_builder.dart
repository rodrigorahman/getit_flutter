import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
import '../types/flutter_getit_typedefs.dart';
import 'flutter_getit_page_router_interface.dart';

class FlutterGetItPageBuilder extends StatefulWidget
    implements FlutterGetItPageRouterInterface {
  /// Page should be loaded
  final WidgetBuilder page;

  /// Binding class that will be preloaded in getIt in the
  /// page load time
  final BindBuilder? binding;

  final String path;

  @override
  String get routeName => path;

  @override
  List<Bind<Object>> get bindings {
    final bindings = <Bind>[];
    if (binding != null) {
      bindings.add(binding!());
    }

    return bindings;
  }

  @override
  WidgetBuilder get view => page;

  const FlutterGetItPageBuilder({
    required this.page,
    required this.path,
    super.key,
    this.binding,
  });

  @override
  State<FlutterGetItPageBuilder> createState() =>
      _FlutterGetItPageBuilderState();
}

class _FlutterGetItPageBuilderState extends State<FlutterGetItPageBuilder> {
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

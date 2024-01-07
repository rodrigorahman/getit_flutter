import 'package:flutter/material.dart';

import '../core/flutter_getit_container_register.dart';
import '../core/flutter_getit_context.dart';
import '../dependency_injector/binds/bind.dart';
import '../dependency_injector/injector.dart';
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

  const FlutterGetItPageBuilder(
      {super.key, required this.page, this.binding, required this.path});

  @override
  State<FlutterGetItPageBuilder> createState() =>
      _FlutterGetItPageBuilderState();
}

class _FlutterGetItPageBuilderState extends State<FlutterGetItPageBuilder> {
  late final String routeId;
  late FlutterGetItContainerRegister containerRegister;

  @override
  void initState() {
    routeId = widget.routeName;
    containerRegister = Injector.get<FlutterGetItContainerRegister>()
      ..register(routeId, widget.bindings)
      ..load(routeId);

    final flutterGetItContext = Injector.get<FlutterGetItContext>();
    flutterGetItContext.registerId(routeId);

    super.initState();
  }

  @override
  void dispose() {
    containerRegister.unRegister(routeId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }
}

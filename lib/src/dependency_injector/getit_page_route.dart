// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import 'bind.dart';

@Deprecated(
    'Please change to [FlutterGetItPageRoute] class, this class will be removed in the next release')
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
      bind.unRegister();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(context);
  }
}

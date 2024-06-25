import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

class FlutterGetItPageRouter {
  final String name;
  final WidgetBuilder page;
  final List<Bind> bindings;
  final List<FlutterGetItPageRouter> pages;

  FlutterGetItPageRouter({
    required this.name,
    required this.page,
    this.bindings = const [],
    this.pages = const [],
  });
}

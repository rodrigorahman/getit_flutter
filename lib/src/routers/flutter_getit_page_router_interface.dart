import 'package:flutter/material.dart';

import '../dependency_injector/binds/bind.dart';

abstract interface class FlutterGetItPageRouterInterface {
  List<Bind> get bindings => [];
  WidgetBuilder get view;
  String get routeName;
}

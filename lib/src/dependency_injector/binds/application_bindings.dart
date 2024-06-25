import 'package:flutter/material.dart';

import '../../../flutter_getit.dart';

@protected
abstract class FlutterGetItBindings {
  List<Bind> bindings();
}

abstract class ApplicationBindings extends FlutterGetItBindings {
  @override
  List<Bind> bindings();
}

abstract class NavigatorBindings extends FlutterGetItBindings {
  @override
  List<Bind> bindings();
}

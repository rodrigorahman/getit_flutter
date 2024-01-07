import 'package:flutter/material.dart';

import '../core/flutter_getit_container_register.dart';
import '../dependency_injector/injector.dart';

class DebugMode {
  late final FlutterGetItContainerRegister _register;

  DebugMode() {
    _register = Injector().call<FlutterGetItContainerRegister>();
  }
  void printRegister() {
    _register.references().forEach((key, value) {
      debugPrint('$key: $value');
    });
  }
}

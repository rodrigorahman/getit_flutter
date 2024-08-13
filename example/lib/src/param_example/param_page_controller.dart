import 'package:example/src/param_example/param_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ParamPageController with FlutterGetItMixin {
  final dtoByInjector = ValueNotifier<ParamPageDto?>(null);

  ParamPageController();

  @override
  void onDispose() {}

  @override
  void onInit() {}

  void setDtoByInjector() {
    dtoByInjector.value = Injector.arguments;
  }
}

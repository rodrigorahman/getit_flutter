import 'package:example/src/param_example/param_page.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ParamPageController with FlutterGetItMixin {
  final ParamPageDto dto;

  ParamPageController(this.dto);

  @override
  void onDispose() {}

  @override
  void onInit() {}
}

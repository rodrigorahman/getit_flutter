import 'package:flutter_getit/flutter_getit.dart';

class FormItemController with FlutterGetItMixin {
  final String name;

  FormItemController({
    required this.name,
  });
  @override
  void onDispose() {}

  @override
  void onInit() {}
}

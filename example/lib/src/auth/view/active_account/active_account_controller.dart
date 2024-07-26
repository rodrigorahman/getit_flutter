import 'package:flutter_getit/flutter_getit.dart';

class ActiveAccountController with FlutterGetItMixin {
  final String name;

  ActiveAccountController({required this.name});
  @override
  void onDispose() {}

  @override
  void onInit() {}
}

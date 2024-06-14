import 'package:flutter_getit/flutter_getit.dart';

class LoginController with FlutterGetItMixin {
  final String name;
  LoginController({required this.name});
  @override
  void dispose() {}

  @override
  void onInit() {
    print('onInit $hashCode');
  }
}

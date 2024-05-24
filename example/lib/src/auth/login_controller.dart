import 'package:flutter_getit/flutter_getit.dart';

class LoginController with FlutterGetItMixin {
  LoginController();
  @override
  void dispose() {}

  @override
  void onInit() {
    print('onInit $hashCode');
  }
}

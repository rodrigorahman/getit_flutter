import 'package:example/src/auth/repository/auth_repository.dart';
import 'package:flutter_getit/flutter_getit.dart';

class LoginController with FlutterGetItMixin {
  final String name;
  final AuthRepository authRepository;
  LoginController({required this.name, required this.authRepository});
  @override
  void onDispose() {}

  @override
  void onInit() {}
}

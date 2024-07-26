import 'package:flutter_getit/flutter_getit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController with FlutterGetItMixin {
  HomeController();

  @override
  void onDispose() {}

  @override
  void onInit() {
    final sp = Injector.get<SharedPreferences>();
  }
}

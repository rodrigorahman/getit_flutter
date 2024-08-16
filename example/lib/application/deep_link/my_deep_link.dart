import 'package:flutter_getit/flutter_getit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDeepLink with FlutterGetItMixin {
  final SharedPreferences sharedPreferences;

  MyDeepLink(this.sharedPreferences);
  @override
  void onDispose() {}

  @override
  void onInit() {}
}

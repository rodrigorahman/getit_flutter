import 'dart:async';

import 'package:flutter_getit/flutter_getit.dart';

import 'model/user_model.dart';

final class UserSession with FlutterGetItMixin {
  static final _me = StreamController<UserModel?>.broadcast();
  static Stream<UserModel?> get me => _me.stream;
  late final Stream periodicReset;

  static void updateMe(UserModel? user) {
    _me.add(user);
  }

  @override
  void onDispose() {
    _me.close();
  }

  @override
  void onInit() {}
}

import 'dart:developer';

import 'package:example/application/bindings/application_bindings.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'initialize_bloc.dart';

class InitializeController implements InitializeBloc, FlutterGetItMixin {
  InitializeController();
  @override
  void onDispose() {}

  @override
  void onInit() async {
    final spByAsync = Injector.get<SharedPreferences>();
    final myTest = await Injector.getAsync<AsyncTest>();
    log(spByAsync.toString());
    log(myTest.toString());
  }
}

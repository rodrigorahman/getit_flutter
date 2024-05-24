import 'package:example/application/bindings/application_bindings.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'initialize_bloc.dart';

class InitializeController implements InitializeBloc, FlutterGetItMixin {
  InitializeController();
  @override
  void dispose() {}

  @override
  void onInit() async {
    await Injector.allReady();
    final spByAsync = Injector.get<SharedPreferences>();
    final myTest = await Injector.getAsync<AsyncTest>();
  }
}

import 'package:flutter_getit/flutter_getit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.singletonAsync(
          (i) async => SharedPreferences.getInstance(),
        ),
        Bind.lazySingletonAsync(
          (i) async => Future.delayed(
            const Duration(seconds: 4),
            () => AsyncTest(),
          ),
        ),
      ];
}

class AsyncTest {}

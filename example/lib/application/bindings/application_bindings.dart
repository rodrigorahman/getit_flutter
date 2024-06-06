import 'package:example/application/deep_link/my_deep_link.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.singleton(
          (i) => MyDeepLink(),
          keepAlive: true,
        ),
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

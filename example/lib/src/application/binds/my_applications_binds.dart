import 'package:flutter_getit/flutter_getit.dart';

class MyApplicationsBinds extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.singletonAsync(
          (i) async => await Future.delayed(
            const Duration(seconds: 2),
            () => FakeAsyncService(),
          ),
        ),
      ];
}

class FakeAsyncService extends FlutterGetItController {
  @override
  void onDispose() {}

  @override
  void onInit() {}
}

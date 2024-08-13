import 'package:example/src/param_example/param_page.dart';
import 'package:example/src/param_example/param_page_controller.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ParamExampleModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Params';

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Page',
          bindings: [
            Bind.lazySingleton(
              (i) => ParamPageController(),
            ),
          ],
          builder: (context) {
            return const ParamPage();
            /*  return switch (isReady) {
              true => const ParamPage(),
              false => loader ?? const CircularProgressIndicator(),
            }; */
          },
        ),
      ];
}

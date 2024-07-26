import 'package:example/src/landing/initialize_controller.dart';
import 'package:example/src/landing/initialize_page.dart';
import 'package:example/src/landing/presentation_page.dart';
import 'package:flutter_getit/flutter_getit.dart';

class LandingModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Landing';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Initialize',
          page: (context) => const InitializePage(),
          bindings: [
            Bind.lazySingleton<InitializeController>(
              (i) => InitializeController(),
            ),
          ],
        ),
        FlutterGetItPageRouter(
          name: '/Presentation',
          page: (context) => const PresentationPage(),
          bindings: [],
        ),
      ];

  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

import 'package:example/src/landing/initialize_controller.dart';
import 'package:example/src/landing/initialize_page.dart';
import 'package:example/src/landing/presentation_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_getit/flutter_getit.dart';

class LandingModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Landing';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<InitializeController>(
          (i) => InitializeController(),
        ),
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/Initialize': (context) => const InitializePage(),
        '/Presentation': (context) => const PresentationPage(),
      };
}

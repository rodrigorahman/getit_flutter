import 'package:example/src/home/home_page.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Home';
  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Page',
          page: (context) => HomePage(),
          bindings: [],
        ),
      ];

  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

import 'package:example/src/home/home_page.dart';
import 'package:example/src/loader/load_dependencies.dart';
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
          page: (context, isReady, loader) => switch (isReady) {
            true => HomePage(),
            false => loader ?? const WidgetLoadDependencies(),
          },
          bindings: [],
        ),
      ];

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

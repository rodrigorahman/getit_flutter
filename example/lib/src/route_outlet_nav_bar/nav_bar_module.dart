import 'package:example/src/loader/load_dependencies.dart';
import 'package:example/src/nav_bar/my_nav_bar.dart';
import 'package:flutter_getit/flutter_getit.dart';

class NavBarModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/RootNavBar';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Root',
          builderAsync: (context, isReady, loader) => switch (isReady) {
            true => const MyNavBar(),
            false => loader ?? const WidgetLoadDependencies(),
          },
        ),
      ];

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

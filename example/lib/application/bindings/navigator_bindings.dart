import 'package:example/src/home/home_controller.dart';
import 'package:example/src/nav_bar/my_nav_bar_helper_controller.dart';
import 'package:flutter_getit/flutter_getit.dart';

class MyNavigatorBindings extends NavigatorBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.singleton(
          (i) => HomeController(),
          keepAlive: true,
          tag: 'HomeController',
        ),
        Bind.lazySingleton<MyNavBarHelperController>(
          (i) => MyNavBarHelperController(),
        ),
      ];
}

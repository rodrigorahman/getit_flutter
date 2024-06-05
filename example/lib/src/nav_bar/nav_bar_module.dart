import 'package:example/src/nav_bar/my_nav_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_getit/flutter_getit.dart';

class NavBarModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/RootNavBar';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/Root': (context) => const MyNavBar(),
      };
}

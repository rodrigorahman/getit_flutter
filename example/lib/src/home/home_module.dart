import 'package:example/src/home/home_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Home';
  @override
  List<Bind<Object>> get bindings => [];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/Page': (context) => HomePage(),
      };
}

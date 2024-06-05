import 'package:example/src/auth/login_controller.dart';
import 'package:example/src/auth/login_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_getit/flutter_getit.dart';

class AuthModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Auth';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => LoginController(
            name: 'By AuthModule Bindings',
          ),
        )
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/Login': (context) => LoginPage(
              controller: context.get(),
            ),
      };
}

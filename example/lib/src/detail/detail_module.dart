import 'package:example/src/detail/detail_controller.dart';
import 'package:example/src/detail/detail_page.dart';
import 'package:example/src/detail/detail_super_controller.dart';
import 'package:example/src/detail/detail_super_page.dart';
import 'package:flutter_getit/flutter_getit.dart';

class DetailModule extends FlutterGetItModule {
  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {}

  @override
  String get moduleRouteName => '/Detail';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Detail',
          page: (context) => DetailPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<DetailController>(
              (i) => DetailController(),
            ),
          ],
        ),
        FlutterGetItPageRouter(
          name: '/DetailSuper',
          page: (context) => DetailSuperPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<DetailSuperController>(
              (i) => DetailSuperController(),
            ),
          ],
        ),
      ];
}

/* class AuthModule extends FlutterGetItModuleV2 {
  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {}

  @override
  String get moduleRouteName => '/Auth';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<AuthRepository>(
          (i) => AuthRepository(
            restClient: i(),
            api: i(),
          ),
        ),
      ];

  @override
  List<FlutterGetItPage> get pages => [
        FlutterGetItPage(
          name: '/Login',
          page: (context) => LoginPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<LoginController>(
              (i) => LoginController(),
            ),
          ],
        ),
        FlutterGetItPage(
          name: '/Register',
          page: (context) => RegisterPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<RegisterController>(
              (i) => RegisterController(),
            ),
          ],
        ),
        FlutterGetItPage(
          name: '/ActiveAccount',
          page: (context) => ActiveAccountPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<AuthCodeRepository>(
              (i) => AuthCodeRepository(),
            ),
            Bind.lazySingleton<ActiveAccountController>(
              (i) => ActiveAccountController(
                codeRepository: i(),
              ),
            ),
          ],
        ),
      ];
}
 */

import 'package:example/src/auth/repository/auth_repository.dart';
import 'package:example/src/auth/view/active_account/active_account_controller.dart';
import 'package:example/src/auth/view/active_account/active_account_page.dart';
import 'package:example/src/auth/view/active_account/validate_email_controller.dart';
import 'package:example/src/auth/view/login/login_controller.dart';
import 'package:example/src/auth/view/login/login_page.dart';
import 'package:example/src/auth/view/register/register_controller.dart';
import 'package:example/src/auth/view/register/register_page.dart';
import 'package:example/src/auth/view/register/register_step_two/register_page_step_two.dart';
import 'package:example/src/auth/view/register/register_step_two/register_page_step_two_controller.dart';
import 'package:flutter_getit/flutter_getit.dart';

class AuthModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Auth';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<AuthRepository>(
          (i) => AuthRepository(),
        ),
      ];

  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {}

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Login',
          page: (context) => LoginPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<LoginController>(
              (i) => LoginController(name: 'Login'),
            ),
          ],
        ),
        FlutterGetItPageRouter(
          name: '/Register',
          page: (context) => RegisterPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<RegisterController>(
              (i) => RegisterController(),
            ),
          ],
          pages: [
            FlutterGetItPageRouter(
              name: '/StepTwo',
              page: (context) => RegisterPageStepTwo(
                controller: context.get(),
              ),
              bindings: [
                Bind.lazySingleton<RegisterStepTwoController>(
                  (i) => RegisterStepTwoController(),
                ),
              ],
            ),
          ],
        ),
        FlutterGetItPageRouter(
          name: '/ActiveAccount',
          page: (context) => const ActiveAccountPage(),
          bindings: [
            Bind.lazySingleton<ActiveAccountPageDependencies>(
              (i) => (
                controller: ActiveAccountController(name: 'MyName'),
                validateEmailController:
                    ValidateEmailController(email: 'fgetit@injector'),
              ),
            ),
          ],
        ),
      ];
}

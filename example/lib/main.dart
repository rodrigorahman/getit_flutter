import 'package:example/application/bindings/application_bindings.dart';
import 'package:example/application/middleware/print_middleware.dart';
import 'package:example/src/auth/repository/auth_repository.dart';
import 'package:example/src/auth/view/active_account/active_account_controller.dart';
import 'package:example/src/auth/view/active_account/active_account_page.dart';
import 'package:example/src/auth/view/active_account/validate_email_controller.dart';
import 'package:example/src/auth/view/login/login_controller.dart';
import 'package:example/src/auth/view/login/login_page.dart';
import 'package:example/src/auth/view/register/register_controller.dart';
import 'package:example/src/auth/view/register/register_page.dart';
import 'package:example/src/landing/landing_module.dart';
import 'package:example/src/loader/load_dependencies.dart';
import 'package:example/src/nav_bar/nav_bar_module.dart';
import 'package:example/src/route_outlet_nav_bar/my_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: MyApplicationBindings(),
      middlewares: [
        PrintMiddleware(),
      ],
      modules: [
        LandingModule(),
        NavBarModule(),
      ],
      // loggerConfig: MyDebugLog(),
      pages: [
        FlutterGetItModuleRouter(
          name: '/outlet',
          pages: [
            FlutterGetItPageRouter(
              name: '/',
              builderAsync: (context, isReady, loader) => switch (isReady) {
                true => const RouteOutletMyNavBar(),
                false => loader ?? const WidgetLoadDependencies(),
              },
              bindings: [],
            ),
          ],
        ),
        FlutterGetItModuleRouter(
          name: '/Auth',
          onInit: (i) => debugPrint('hi by /Auth'),
          onDispose: (i) => debugPrint('bye by /Auth'),
          bindings: [
            Bind.lazySingleton<AuthRepository>(
              (i) => AuthRepository(),
            ),
          ],
          pages: [
            FlutterGetItPageRouter(
              name: '/Login',
              builderAsync: (context, isReady, loader) => switch (isReady) {
                true => LoginPage(
                    controller: context.get(),
                  ),
                false => loader ?? const WidgetLoadDependencies(),
              },
              bindings: [
                Bind.lazySingleton<LoginController>(
                  (i) => LoginController(
                    name: 'Login',
                    authRepository: i(),
                  ),
                ),
              ],
            ),
            FlutterGetItModuleRouter(
              name: '/Register',
              bindings: [
                Bind.lazySingleton<RegisterController>(
                  (i) => RegisterController(),
                ),
              ],
              onInit: (i) => debugPrint('hi by /Register'),
              onDispose: (i) => debugPrint('bye by /Register'),
              pages: [
                FlutterGetItPageRouter(
                  name: '/Page',
                  builderAsync: (context, isReady, loader) => switch (isReady) {
                    true => RegisterPage(
                        controller: context.get(),
                      ),
                    false => loader ?? const WidgetLoadDependencies(),
                  },
                  bindings: [
                    Bind.lazySingleton<RegisterController>(
                      (i) => RegisterController(),
                    ),
                  ],
                ),
                FlutterGetItModuleRouter(
                  name: '/ActiveAccount',
                  bindings: [
                    Bind.lazySingleton<ActiveAccountPageDependencies>(
                      (i) => (
                        controller: ActiveAccountController(name: 'MyName'),
                        validateEmailController:
                            ValidateEmailController(email: 'fgetit@injector'),
                      ),
                    ),
                  ],
                  pages: [
                    FlutterGetItPageRouter(
                      name: '/Page',
                      builderAsync: (context, isReady, loader) =>
                          switch (isReady) {
                        true => const ActiveAccountPage(),
                        false => loader ?? const WidgetLoadDependencies(),
                      },
                      bindings: [],
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
      builder: (context, routes, isReady) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/Landing/Initialize',
          routes: routes,
          builder: (context, child) => switch (isReady) {
            true => child ?? const SizedBox.shrink(),
            false => const WidgetLoadDependencies(),
          },
        );
      },
    );
  }
}

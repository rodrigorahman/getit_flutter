import 'package:example/application/bindings/navigator_bindings.dart';
import 'package:example/application/middleware/module_middleware.dart';
import 'package:example/application/middleware/page_middleware.dart';
import 'package:example/src/auth/repository/auth_repository.dart';
import 'package:example/src/auth/view/active_account/active_account_controller.dart';
import 'package:example/src/auth/view/active_account/active_account_page.dart';
import 'package:example/src/auth/view/active_account/validate_email_controller.dart';
import 'package:example/src/auth/view/login/login_controller.dart';
import 'package:example/src/auth/view/login/login_page.dart';
import 'package:example/src/auth/view/register/register_controller.dart';
import 'package:example/src/auth/view/register/register_page.dart';
import 'package:example/src/detail/detail_module.dart';
import 'package:example/src/home/home_module.dart';
import 'package:example/src/random/random_controller.dart';
import 'package:example/src/random/random_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

final internalNav = GlobalKey<NavigatorState>();

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterGetIt.navigator(
        navigatorName: 'NAVbarProducts',
        bindings: MyNavigatorBindings(),
        pages: [
          FlutterGetItModuleRouter(
            name: '/Random',
            bindings: [
              Bind.lazySingleton<RandomController>(
                (i) => RandomController('Random by FlutterGetItPageRouter'),
              ),
            ],
            pages: [
              FlutterGetItPageRouter(
                name: '/Page',
                page: (context) => const RandomPage(),
                bindings: [
                  Bind.lazySingleton<RandomController>(
                    (i) => RandomController('Random by FlutterGetItPageRouter'),
                  ),
                ],
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
                page: (context) => LoginPage(
                  controller: context.get(),
                ),
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
                middlewares: [
                  ModuleMiddleware(),
                ],
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
                    middlewares: [
                      PageMiddleware(),
                    ],
                    name: '/Page',
                    page: (context) => RegisterPage(
                      controller: context.get(),
                    ),
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
                        page: (context) => const ActiveAccountPage(),
                        bindings: [],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
        modules: [
          HomeModule(),
          DetailModule(),
          /* AuthModule(),
          ProductsModule(), */
        ],
        builder: (context, routes) => Navigator(
          key: internalNav,
          initialRoute: '/Home/Page',
          observers: const [],
          onGenerateRoute: (settings) {
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  routes[settings.name]?.call(context) ?? const Placeholder(),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (_currentIndex != value) {
            switch (value) {
              case 0:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Home/Page', (_) => false);
              case 1:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Products/Page', (_) => false);
              case 2:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Home/Page', (_) => false);
              case 3:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Products/Page', (_) => false);
            }
            setState(() {
              _currentIndex = value;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.production_quantity_limits,
              color: Colors.blueAccent,
            ),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.production_quantity_limits,
              color: Colors.blueAccent,
            ),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}

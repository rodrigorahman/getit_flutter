import 'package:example/src/auth/auth_module.dart';
import 'package:example/src/home/home_controller.dart';
import 'package:example/src/home/home_module.dart';
import 'package:example/src/nav_bar/my_nav_bar_helper_controller.dart';
import 'package:example/src/products/products_module.dart';
import 'package:example/src/random/random_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

final internalNav = GlobalKey<NavigatorState>();

class MyNavBar extends StatelessWidget {
  const MyNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterGetItNavigator(
        bindingsBuilder: () => [
          Bind.singleton(
            (i) => HomeController(),
            keepAlive: true,
          ),
          Bind.lazySingleton<MyNavBarHelperController>(
            (i) => MyNavBarHelperController(),
          ),
        ],
        pages: const [
          RandomPage(),
        ],
        modules: [
          HomeModule(),
          ProductsModule(),
          AuthModule(),
        ],
        builder: (context, routes, observer) => Navigator(
          key: internalNav,
          initialRoute: '/Home/Page',
          observers: [observer],
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
        onTap: (value) {
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

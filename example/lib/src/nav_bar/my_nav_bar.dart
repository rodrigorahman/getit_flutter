import 'package:example/src/auth/auth_module.dart';
import 'package:example/src/home/home_module.dart';
import 'package:example/src/products/products_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

final internalNav = GlobalKey<NavigatorState>();

class MyNavBar extends StatelessWidget {
  const MyNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterGetItNavigator(
        modules: [
          HomeModule(),
          ProductsModule(),
          AuthModule(),
        ],
        builder: (context, onGenerateRoute) => Navigator(
          key: internalNav,
          initialRoute: '/Home/Page',
          onGenerateRoute: (settings) {
            final page = onGenerateRoute(settings);

            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  page ?? const Placeholder(),
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

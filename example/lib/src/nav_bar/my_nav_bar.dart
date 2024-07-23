import 'package:example/application/bindings/navigator_bindings.dart';
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
          FlutterGetItPageRouter(
            name: '/RandomPage',
            page: (context) => const RandomPage(),
            bindings: [
              Bind.lazySingleton<RandomController>(
                (i) => RandomController('Random by FlutterGetItPageRouter'),
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

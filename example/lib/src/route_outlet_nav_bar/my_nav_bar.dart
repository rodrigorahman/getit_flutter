import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

final internalNav = GlobalKey<NavigatorState>();
final internalNav2 = GlobalKey<NavigatorState>();

class RouteOutletMyNavBar extends StatefulWidget {
  const RouteOutletMyNavBar({super.key});

  @override
  State<RouteOutletMyNavBar> createState() => _RouteOutletMyNavBarState();
}

class _RouteOutletMyNavBarState extends State<RouteOutletMyNavBar> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterGetItRouteOutlet(
        initialRoute: '/Auth/Login',
        navKey: internalNav,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (_currentIndex != value) {
            switch (value) {
              case 0:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Auth/Login', (_) => false);
              case 1:
                internalNav.currentState?.pushNamedAndRemoveUntil(
                    '/Auth/Register/Page', (_) => false);
              case 2:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/RootNavBar/Root', (_) => false);
              case 3:
                internalNav.currentState?.pushNamedAndRemoveUntil(
                    '/Landing/Initialize', (_) => false);
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
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.production_quantity_limits,
              color: Colors.blueAccent,
            ),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Custom NavBar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Presentation',
          ),
        ],
      ),
    );
  }
}

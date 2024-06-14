import 'package:example/application/bindings/application_bindings.dart';
import 'package:example/src/landing/landing_module.dart';
import 'package:example/src/nav_bar/nav_bar_module.dart';
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
      debugMode: true,
      modules: [
        LandingModule(),
        NavBarModule(),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/Landing/Initialize',
          routes: routes,
        );
      },
    );
  }
}

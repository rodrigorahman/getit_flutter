import 'dart:developer';

import 'package:example/application/deep_link/my_deep_link.dart';
import 'package:example/src/landing/initialize_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class InitializePage extends StatelessWidget {
  const InitializePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<InitializeController>();
    final deepLink = Injector.get<MyDeepLink>();
    log(controller.toString());
    log(deepLink.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialize page'),
      ),
      body: Center(
        child: Column(
          children: [
            const FlutterLogo(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Landing/Presentation', (route) => false);
              },
              child: const Text('Ir a Presentation'),
            ),
          ],
        ),
      ),
    );
  }
}

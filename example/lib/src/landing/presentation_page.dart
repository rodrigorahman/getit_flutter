import 'dart:developer';

import 'package:example/src/landing/landing_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class PresentationPage extends StatelessWidget {
  const PresentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<PresentationController>();
    log(controller.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentation'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/RootNavBar/Root',
                  (route) => false,
                );
              },
              child: const Text('Ir a RootNav'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/outlet/',
                  (route) => false,
                );
              },
              child: const Text('Ir a RouteOutlet'),
            ),
          ],
        ),
      ),
    );
  }
}

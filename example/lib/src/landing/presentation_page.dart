import 'package:flutter/material.dart';

class PresentationPage extends StatelessWidget {
  const PresentationPage({super.key});

  @override
  Widget build(BuildContext context) {
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

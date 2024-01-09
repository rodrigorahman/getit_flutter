import 'package:flutter/material.dart';

import 'navigator/flutter_getit_navigator_observer.dart';

class UnknownRoutePage extends StatelessWidget {
  final FlutterGetItNavigatorObserver observer;
  final RouteSettings settings;
  const UnknownRoutePage(
      {super.key, required this.observer, required this.settings});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red.shade100,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Oops! This route ${settings.name} doesn\'t exist.'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, observer.previousRoute ?? '/');
                      },
                      child: const Text('Return to previous route'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WidgetLoadDependencies extends StatelessWidget {
  const WidgetLoadDependencies({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('⏰ - Loading dependencies...'),
      ),
    );
  }
}

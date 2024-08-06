import 'package:flutter/material.dart';

class MyWidgetBindLoader extends StatelessWidget {
  const MyWidgetBindLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Loading dependencies...'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FlutterGetitSimpleLoader extends StatelessWidget {
  const FlutterGetitSimpleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator.adaptive(),
    ));
  }
}

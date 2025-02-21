import 'package:flutter/material.dart';

class FlutterGetItLoader extends StatelessWidget {
  const FlutterGetItLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

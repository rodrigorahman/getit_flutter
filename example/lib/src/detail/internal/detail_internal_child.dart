import 'package:example/src/detail/internal/detail_internal_repository.dart';
import 'package:flutter/material.dart';

class DetailInternalChild extends StatelessWidget {
  final DetailInternalRepository repository;
  const DetailInternalChild({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailInternalChild'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacementNamed('/Detail/Factories/One/Internal/Page');
        },
        child: const Text('Detail Internal - pushReplacementNamed'),
      )),
    );
  }
}

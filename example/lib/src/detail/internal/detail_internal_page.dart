import 'package:example/src/detail/internal/detail_internal_repository.dart';
import 'package:flutter/material.dart';

class DetailInternalPage extends StatelessWidget {
  final DetailInternalRepository repository;
  const DetailInternalPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailInternalPage'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/Detail/Factories/One/Internal/Page/Child');
        },
        child: const Text('Detail Internal Child'),
      )),
    );
  }
}

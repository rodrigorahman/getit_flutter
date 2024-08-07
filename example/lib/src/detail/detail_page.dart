import 'package:example/src/detail/detail_controller.dart';
import 'package:flutter/material.dart';

import 'widget/form_item.dart';

class DetailPage extends StatelessWidget {
  final DetailController controller;

  const DetailPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home detail'),
      ),
      body: Center(
        child: Column(
          children: [
            const FormItem(
              id: '',
            ),
            const Divider(),
            const FormItem(
              id: '',
            ),
            const Divider(),
            const FormItem(
              id: 'FormItem3',
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/Detail/Factories/Two');
              },
              child: const Text('Detail Two - pushReplacementNamed'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Detail/Factories/Two');
              },
              child: const Text('Detail Two'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/Detail/Factories/One/Internal/Page');
              },
              child: const Text('Detail Internal'),
            ),
          ],
        ),
      ),
    );
  }
}

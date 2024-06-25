import 'package:example/src/detail/detail_super_controller.dart';
import 'package:example/src/detail/widget/form_item.dart';
import 'package:flutter/material.dart';

class DetailSuperPage extends StatelessWidget {
  final DetailSuperController controller;
  const DetailSuperPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home detail Super'),
      ),
      body: const Center(
          child: Column(
        children: [
          FormItem(
            id: 'FormItem4',
          ),
          Divider(),
          FormItem(
            id: 'FormItem5',
          ),
          Divider(),
          FormItem(
            id: 'FormItem6',
          ),
        ],
      )),
    );
  }
}

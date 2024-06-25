import 'package:example/src/detail/widget/form_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class FormItem extends StatelessWidget {
  final String id;
  const FormItem({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FlutterGetItWidget(
      name: id,
      binds: [
        Bind.factory(
          (i) => FormItemController(
            name: 'FormItemController',
          ),
        ),
      ],
      onDispose: () {
        Injector.unRegisterFactory<FormItemController>(id);
      },
      builder: (context) {
        final fGetIt = context.get<FormItemController>(factoryTag: id);
        return Column(
          children: [
            Text(fGetIt.name),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: fGetIt.name,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        );
      },
    );
  }
}

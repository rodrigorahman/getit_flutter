import 'package:example/src/param_example/param_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

typedef ParamPageDto = ({String name, DateTime date});

class ParamPage extends StatelessWidget {
  const ParamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<ParamPageController>();

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: controller.dtoByInjector,
          builder: (context, dtoByInjector, child) {
            return Text(
              switch (dtoByInjector) {
                null => 'null',
                _ => dtoByInjector.name,
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        controller.setDtoByInjector();
      }),
      body: Center(
        child: Column(
          children: [
            const Text('Dto by injector'),
            ValueListenableBuilder(
              valueListenable: controller.dtoByInjector,
              builder: (context, dtoByInjector, child) {
                return Text(
                  switch (dtoByInjector) {
                    null => 'null',
                    _ => dtoByInjector.date.toIso8601String()
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

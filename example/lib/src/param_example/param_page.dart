import 'package:example/src/param_example/param_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

typedef ParamPageDto = ({String name, DateTime date});

class ParamPage extends StatelessWidget {
  const ParamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dto = ModalRoute.of(context)?.settings.arguments as ParamPageDto;
    final controller = Injector.get<ParamPageController>(parameters: dto);

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.dto.name),
      ),
      body: Center(
        child: Text(controller.dto.date.toIso8601String()),
      ),
    );
  }
}

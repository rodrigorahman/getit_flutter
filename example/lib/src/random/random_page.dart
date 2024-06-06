import 'package:example/src/random/random_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class RandomPage extends FlutterGetItPageRouter {
  const RandomPage({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<RandomController>(
          (i) => RandomController('Random by FlutterGetItPageRouter'),
        ),
      ];

  @override
  String get routeName => '/RandomPage';

  @override
  WidgetBuilder get view => (context) => Scaffold(
        appBar: AppBar(
          title: Text(context.get<RandomController>().title),
        ),
        body: Container(),
      );
}

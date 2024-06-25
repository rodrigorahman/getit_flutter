import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

//Stateless
class FlutterGetItView<T extends Object> extends StatelessWidget {
  T get fGetIt => Injector.get<T>();
  const FlutterGetItView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

mixin FGetItInjectorMixin<T extends Object> {
  final T _controller = Injector.get<T>();
  T get fGetIt => _controller;
}

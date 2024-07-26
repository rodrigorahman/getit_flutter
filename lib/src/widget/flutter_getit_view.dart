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

import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

abstract class FlutterGetItAsyncBindings extends FlutterGetItAsyncMiddleware {
  @override
  Future<MiddlewareResult> execute(RouteSettings? route) async {
    await Injector.allReady();
    return MiddlewareResult.next;
  }
}

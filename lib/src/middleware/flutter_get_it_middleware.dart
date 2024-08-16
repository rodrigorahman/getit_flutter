import 'dart:async';

import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

abstract class FlutterGetItMiddleware {
  bool executeWhen(RouteSettings? route) => true;
  FutureOr<void> onFail(RouteSettings? route,
      FlutterGetItMiddlewareContext fContext, MiddlewareResult result,
      {dynamic error}) {
    if (fContext.canPop()) {
      fContext.pop();
    }
  }
}

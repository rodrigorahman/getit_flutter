import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class PageMiddleware extends FlutterGetItAsyncMiddleware {
  @override
  Future<MiddlewareResult> execute(RouteSettings? route) async {
    return MiddlewareResult.next;
  }

  @override
  FutureOr<void> onFail(
      RouteSettings? route,
      FlutterGetItMiddlewareContext fcontext,
      error,
      MiddlewareResult result) async {
    super.onFail(route, fcontext, error, result);
    await fcontext.bottomSheet(
        builder: (_) => Scaffold(body: Center(child: Text(error.toString()))));
  }
}

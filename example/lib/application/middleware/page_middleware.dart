import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class PageMiddleware extends FlutterGetItAsyncMiddleware {
  @override
  Future<MiddlewareResult> execute(RouteSettings? route) async {
    log("Vindo da Page! ===== ${route?.name ?? 'SEM ROTA'}");
    return MiddlewareResult.next;
  }

  @override
  FutureOr<void> onFail(RouteSettings? route,
      FlutterGetItMiddlewareContext fContext, MiddlewareResult result,
      {dynamic error}) async {
    super.onFail(route, fContext, result, error: error);
    await fContext.bottomSheet(
        builder: (_) => Scaffold(body: Center(child: Text(error.toString()))));
  }
}

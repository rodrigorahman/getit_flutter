import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class PrintMiddleware extends FlutterGetItSyncMiddleware {
  @override
  MiddlewareResult execute(RouteSettings? route) {
    log("DE APPLICATION! ===== ${route?.name ?? 'SEM ROTA'}");

    if (executeWhen(route)) {
      return MiddlewareResult.next;
    }
    return MiddlewareResult.next;
  }

  @override
  bool executeWhen(RouteSettings? route) {
    if (route?.name == null) {
      return true;
    } else {
      if (route?.name?.contains('Register') ?? false) {
        return false;
      }
      return true;
    }
  }
}

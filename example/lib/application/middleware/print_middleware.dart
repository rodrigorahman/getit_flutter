import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class PrintMiddleware extends FlutterGetItSyncMiddleware {
  @override
  MiddlewareResult execute(RouteSettings? route) {
    if (executeWhen(route)) {
      log("VINDO DO APPLICATION SOMENTE EM ROTAS N TEM REGISTER! ===== ${route?.name ?? 'SEM ROTA'}");
      return MiddlewareResult.failure;
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

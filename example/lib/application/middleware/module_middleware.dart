import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ModuleMiddleware extends FlutterGetItSyncMiddleware {
  @override
  MiddlewareResult execute(RouteSettings? route) {
    // log("VINDO DO MODULO ===== ${route?.name ?? 'SEM ROTA'}");
    return MiddlewareResult.next;
  }
}

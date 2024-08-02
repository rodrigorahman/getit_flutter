import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import 'flutter_get_it_middleware.dart';

abstract class FlutterGetItSyncMiddleware extends FlutterGetItMiddleware {
  MiddlewareResult execute(RouteSettings? route) {
    return MiddlewareResult.next;
  }
}

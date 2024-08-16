import 'dart:async';

import 'package:flutter/material.dart';

import '../enum/middleware_result.dart';
import 'flutter_get_it_middleware.dart';

abstract class FlutterGetItAsyncMiddleware extends FlutterGetItMiddleware {
  Future<MiddlewareResult> execute(RouteSettings? route);
  Widget onExecute = const Center(child: CircularProgressIndicator.adaptive());
}

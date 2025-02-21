import 'dart:async';

import 'package:flutter/widgets.dart';

export 'package:flutter/widgets.dart';

enum MiddlewareAction { skip, execute }

enum MiddlewareStatus { failure, success }

class FlutterGetItMiddlewareArguments {
  final dynamic arguments;

  FlutterGetItMiddlewareArguments(this.arguments);
}

abstract class FlutterGetItMiddleware {
  MiddlewareAction when(String path);
  FutureOr<MiddlewareStatus> execute(dynamic arguments);
  void onFailure(BuildContext context, dynamic arguments);
}

abstract class FlutterGetItSyncMiddleware extends FlutterGetItMiddleware {
  @override
  MiddlewareAction when(String path) {
    return MiddlewareAction.execute;
  }

  @override
  MiddlewareStatus execute(dynamic arguments) {
    return MiddlewareStatus.success;
  }

  @override
  void onFailure(BuildContext context, dynamic arguments) {
    return;
  }
}

abstract class FlutterGetItAsyncMiddleware extends FlutterGetItMiddleware {
  @override
  MiddlewareAction when(String path) {
    return MiddlewareAction.execute;
  }

  @override
  FutureOr<MiddlewareStatus> execute(dynamic arguments) {
    return Future.delayed(
      const Duration(seconds: 4),
      () => MiddlewareStatus.success,
    );
  }

  @override
  void onFailure(BuildContext context, dynamic arguments) {
    return;
  }
}

class FlutterGetItInitializationMiddleware {}

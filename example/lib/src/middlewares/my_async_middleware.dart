import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class MyAsyncMiddleware implements FlutterGetItAsyncMiddleware {
  @override
  FutureOr<MiddlewareStatus> execute(dynamic arguments) {
    return Future.delayed(
      const Duration(microseconds: 500),
      () => MiddlewareStatus.success,
    );
  }

  @override
  void onFailure(BuildContext context, dynamic arguments) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'MyAsyncMiddleware failed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  MiddlewareAction when(String path) {
    if (path != '/') {
      return MiddlewareAction.execute;
    }
    return MiddlewareAction.skip;
  }
}

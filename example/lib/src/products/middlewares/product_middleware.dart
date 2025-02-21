import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ProductMiddleware implements FlutterGetItSyncMiddleware {
  @override
  MiddlewareStatus execute(arguments) {
    if (arguments is String && arguments == 'Block') {
      return MiddlewareStatus.failure;
    }
    return MiddlewareStatus.success;
  }

  @override
  void onFailure(BuildContext context, arguments) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Middleware ProductMiddleware failed',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    return;
  }

  @override
  MiddlewareAction when(String path) {
    return MiddlewareAction.execute;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class AuthMiddleware extends FlutterGetItAsyncMiddleware {
  @override
  Future<MiddlewareResult> execute(RouteSettings? route) async {
    await Future.delayed(const Duration(seconds: 1));
    return MiddlewareResult.next;
  }

  @override
  Widget get onExecute => const Scaffold(
        body: Center(
          child: Icon(
            Icons.lock,
            color: Colors.red,
            size: 100,
          ),
        ),
      );
}

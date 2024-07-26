import 'package:flutter/material.dart';

final class FlutterGetItNavigatorObserver extends NavigatorObserver {
  String? currentRoute;
  String? previousRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = currentRoute;
    currentRoute = route.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = currentRoute;
    currentRoute = route.settings.name;
    // GetIt.I.get<FlutterGetItContext>().returnToLastId();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    previousRoute = currentRoute;
    currentRoute = newRoute?.settings.name;
  }
}

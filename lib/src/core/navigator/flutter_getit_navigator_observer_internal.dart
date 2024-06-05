import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';

class FlutterGetItNavigatorObserverInternal extends NavigatorObserver {
  late final FlutterGetItNavigatorObserver obsRoot;
  void init() {
    obsRoot = GetIt.I.get<FlutterGetItNavigatorObserver>();
  }

  String? currentRoute;
  String? previousRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      obsRoot.didPush(route, previousRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      obsRoot.didPop(route, previousRoute);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      obsRoot.didReplace(newRoute: newRoute, oldRoute: oldRoute);
}

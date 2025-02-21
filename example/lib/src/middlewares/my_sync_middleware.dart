/* import 'package:flutter_getit/flutter_getit.dart';

class MySyncMiddleware implements FlutterGetItSyncMiddlewareV4 {
  @override
  MiddlewareStatus execute(FlutterGetItRouteBase route) {
    if (route.fullName == '/Account/Profile') {
      return MiddlewareStatus.failure;
    }
    return MiddlewareStatus.success;
  }

  @override
  void onFailure(FlutterGetItRouteBase route) {
    route.navigator?.pop();
  }

  @override
  MiddlewareAction when(FlutterGetItRouteBase route) {
    if (route.fullName.contains('/Account')) {
      return MiddlewareAction.execute;
    }
    return MiddlewareAction.skip;
  }
}
 */

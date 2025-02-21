import 'package:flutter/foundation.dart';

import '../../../../flutter_getit.dart';

class CupertinoDebuggerWrapper extends StatelessWidget {
  final FlutterGetItRouteBase route;
  final Widget child;

  const CupertinoDebuggerWrapper({
    required this.route,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FlutterGetItRouteBase>('Route', route));
  }
}

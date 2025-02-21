import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../flutter_getit.dart';

class FlutterGetItDebuggerWrapper extends StatelessWidget {
  final Widget child;

  const FlutterGetItDebuggerWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
    final route = fGetItWallet.routeStack.last;
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FlutterGetItRouteBase>('Route', route));
  }
}

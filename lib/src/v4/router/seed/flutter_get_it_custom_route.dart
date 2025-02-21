import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../flutter_getit.dart';
import '../../../routers/flutter_get_it_route_params_extractor.dart';
import '../../debug/debug_fill_properties/cupertino_debugger_wrapper.dart';

class FlutterGetItCustomRoute extends PageRouteBuilder {
  final FlutterGetItRoute route;
  FlutterGetItCustomRoute({
    required this.route,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            final params = FlutterGetItRouteParamsExtractor(
              route.fullPath,
              route.fullPath,
            ).extract();

            return route.buildPage?.call(
                  context,
                  animation,
                  secondaryAnimation,
                  ModalRoute.of(context)!.routeParams,
                ) ??
                const SizedBox.shrink();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              route.buildTransition?.call(
                context,
                animation,
                secondaryAnimation,
                child,
              ) ??
              child,
          requestFocus: route.requestFocus,
          maintainState: route.maintainState,
          fullscreenDialog: route.fullscreenDialog,
          allowSnapshotting: route.allowSnapshotting,
          barrierDismissible: route.barrierDismissible,
          opaque: route.opaque,
          barrierColor: route.barrierColor,
          barrierLabel: route.barrierLabel,
          transitionDuration: route.transitionDuration,
          reverseTransitionDuration: route.reverseTransitionDuration,
        );
  bool _isMaterialApp(BuildContext context) =>
      context.findAncestorWidgetOfExactType<MaterialApp>() != null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (kDebugMode) {
      if (_isMaterialApp(context)) {
        return FlutterGetItDebuggerWrapper(
          child: super.buildPage(context, animation, secondaryAnimation),
        );
      }
      return CupertinoDebuggerWrapper(
        route: route,
        child: super.buildPage(context, animation, secondaryAnimation),
      );
    }
    return super.buildPage(context, animation, secondaryAnimation);
  }

  @override
  void dispose() {
    if (!route.isLoader) {
      final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
      fGetItWallet.solveDisposeRoute(route);
    }
    super.dispose();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../../flutter_getit.dart';
import '../../../routers/flutter_get_it_route_params_extractor.dart';
import '../../debug/debug_fill_properties/cupertino_debugger_wrapper.dart';

class FlutterGetItCupertinoRoute extends CupertinoPageRoute {
  final FlutterGetItRoute route;
  FlutterGetItCupertinoRoute({
    super.settings,
    required this.route,
  }) : super(
          title: route.fullPath,
          builder: (context) => const SizedBox.shrink(),
          requestFocus: route.requestFocus,
          maintainState: route.maintainState,
          fullscreenDialog: route.fullscreenDialog,
          allowSnapshotting: route.allowSnapshotting,
          barrierDismissible: route.barrierDismissible,
        );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final params = FlutterGetItRouteParamsExtractor(
      route.fullPath,
      route.fullPath,
    ).extract();
    return CupertinoDebuggerWrapper(
      route: route,
      child: route.buildPage?.call(
            context,
            animation,
            secondaryAnimation,
            ModalRoute.of(context)!.routeParams,
          ) ??
          const SizedBox.shrink(),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return route.buildTransition?.call(
          context,
          animation,
          secondaryAnimation,
          child,
        ) ??
        child;
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

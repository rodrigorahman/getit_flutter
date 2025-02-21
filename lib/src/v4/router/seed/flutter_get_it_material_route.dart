import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../flutter_getit.dart';
import '../../../routers/flutter_get_it_route_params_extractor.dart';

class FlutterGetItMaterialRoute extends MaterialPageRoute {
  final FlutterGetItRoute route;

  FlutterGetItMaterialRoute({
    required this.route,
    super.settings,
  }) : super(
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
    /* if (kDebugMode) {
      return MaterialDebuggerWrapper(
        route: route,
        child: route.buildPage?.call(
              context,
              animation,
              secondaryAnimation,
            ) ??
            const SizedBox.shrink(),
      );
    } */
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
  }

  @override
  void dispose() {
    if (!route.isLoader) {
      final fGetItWallet = GetIt.I.get<FlutterGetItWallet>();
      fGetItWallet.solveDisposeRoute(route);
    }
    super.dispose();
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
}

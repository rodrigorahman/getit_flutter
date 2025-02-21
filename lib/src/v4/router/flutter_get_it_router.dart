import 'package:uuid/uuid.dart';

import '../../../flutter_getit.dart';

const _uuidConfig = Uuid();

abstract class FlutterGetItRouteBase<T> {
  FlutterGetItRouteBase();
  abstract String uuid;
  abstract List<Bind> binds;
  abstract String path;
  abstract String fullPath;
  abstract List<String> parentUUIDs;
  abstract List<FlutterGetItMiddleware> middlewares;
  abstract List<FlutterGetItRouteBase<T>> pages;
  abstract bool isLoader;

  Map<String, String>? extractParameters(String route, String path) {
    final regexPattern = RegExp('^' +
        route.replaceAllMapped(RegExp(r':(\w+)'), (match) => r'([^/]+)') +
        r'$');
    final match = regexPattern.firstMatch(path);
    if (match == null) return null;

    final paramNames =
        RegExp(r':(\w+)').allMatches(route).map((m) => m.group(1)!).toList();

    final paramValues = match
        .groups(
          List.generate(match.groupCount, (i) => i + 1),
        )
        .map((e) => e.toString())
        .toList();

    return Map.fromIterables(paramNames, paramValues);
  }
}

class FlutterGetItModuleRoute<T> extends FlutterGetItRouteBase<T> {
  final bool safeRedirect;
  final String? redirect;

  FlutterGetItModuleRoute({
    required this.path,
    this.binds = const [],
    this.pages = const [],
    this.middlewares = const [],
    this.redirect,
    this.safeRedirect = true,
  })  : parentUUIDs = [],
        uuid = _uuidConfig.v4(),
        fullPath = '',
        isLoader = false;

  @override
  List<FlutterGetItRouteBase<T>> pages;

  @override
  List<Bind<Object>> binds;

  @override
  String path;

  @override
  List<String> parentUUIDs;

  @override
  String uuid;

  @override
  String fullPath;

  @override
  List<FlutterGetItMiddleware> middlewares;

  @override
  bool isLoader;
}

class FlutterGetItRoute<T> extends FlutterGetItRouteBase<T> {
  final bool? requestFocus;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool allowSnapshotting;
  final bool barrierDismissible;
  final bool isCustom;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool opaque;
  final Color? barrierColor;
  final String? barrierLabel;

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    FGetItRouterParams params,
  )? buildPage;

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )? buildTransition;

  FlutterGetItRoute.custom({
    required this.path,
    this.binds = const [],
    this.pages = const [],
    this.middlewares = const [],
    this.buildPage,
    this.buildTransition,
    this.requestFocus,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = false,
    this.barrierDismissible = false,
    this.opaque = true,
    this.barrierColor,
    this.barrierLabel,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  })  : parentUUIDs = [],
        uuid = _uuidConfig.v4(),
        fullPath = '',
        isCustom = true,
        isLoader = false,
        assert(
          buildPage != null || buildTransition != null,
          'Either buildPage or buildTransitions must be defined',
        );

  FlutterGetItRoute({
    required this.path,
    this.binds = const [],
    this.pages = const [],
    this.middlewares = const [],
    this.buildPage,
    this.buildTransition,
    this.requestFocus,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = false,
    this.barrierDismissible = false,
    this.opaque = true,
    this.barrierColor,
    this.barrierLabel,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  })  : parentUUIDs = [],
        uuid = _uuidConfig.v4(),
        fullPath = '',
        isCustom = false,
        isLoader = false,
        assert(
          buildPage != null || buildTransition != null,
          'Either buildPage or buildTransitions must be defined',
        );

  @override
  List<Bind<Object>> binds;

  @override
  List<String> parentUUIDs;

  @override
  List<FlutterGetItRouteBase<T>> pages;

  @override
  String uuid;

  @override
  String fullPath;

  @override
  List<FlutterGetItMiddleware> middlewares;

  @override
  String path;

  @override
  bool isLoader;
}

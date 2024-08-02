import 'package:flutter/material.dart';

class FlutterGetItMiddlewareContext {
  final BuildContext _context;

  FlutterGetItMiddlewareContext(BuildContext context) : _context = context;

  bool canPop() {
    return Navigator.of(_context).canPop();
  }

  Future<T?> pushReplacement<T, TO>(Route<T> newRoute, {TO? result}) {
    return Navigator.of(_context).pushReplacement(newRoute, result: result);
  }

  Future<T?> pushReplacementNamed<T, TO>(String routeName,
      {TO? result, Object? arguments}) {
    return Navigator.of(_context)
        .pushReplacementNamed(routeName, result: result, arguments: arguments);
  }

  Future<T?> pushAndRemoveUntil<T>(
      Route<T> newRoute, bool Function(Route<dynamic>) predicate) {
    return Navigator.of(_context).pushAndRemoveUntil(newRoute, predicate);
  }

  Future<T?> pushNamedAndRemoveUntil<T>(
      String routeName, bool Function(Route<dynamic>) predicate,
      {Object? arguments}) {
    return Navigator.of(_context)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(_context).pop(result);
  }

  // Show a modal
  Future<T?> dialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: _context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  // Show a snackbar
  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  // Show a modal bottom sheet
  Future<T?> bottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
  }) {
    return showModalBottomSheet<T>(
      context: _context,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
    );
  }
}

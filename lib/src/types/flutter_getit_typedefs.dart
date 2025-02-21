import 'package:flutter/cupertino.dart';

import '../dependency_injector/binds/bind.dart';
import '../v4/core/f_get_it.dart';

typedef ApplicationBindingsBuilder = List<Bind> Function();

typedef BindBuilder = Bind Function();

typedef BindRegister<T> = T Function(FGetIt i);
typedef BindAsyncRegister<T> = Future<T> Function(FGetIt i);
typedef ApplicationBuilder = Widget Function(
  BuildContext context,
  Map<String, WidgetBuilder> routes,
  bool isReady,
);

typedef ApplicationBuilderPath = Widget Function(
    BuildContext context, bool isReady, RouteFactory onGenerateRoute);

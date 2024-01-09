import 'package:flutter/cupertino.dart';

import '../dependency_injector/binds/bind.dart';
import '../dependency_injector/injector.dart';

typedef ApplicationBindingsBuilder = List<Bind> Function();

typedef BindBuilder = Bind Function();

typedef BindRegister<T> = T Function(Injector i);

typedef ApplicationBuilder = Widget Function(
  BuildContext context,
  Map<String, WidgetBuilder> routes,
  NavigatorObserver flutterGetItNavObserver,
  Route<dynamic> Function(RouteSettings settings) onUnknownRoute,
);

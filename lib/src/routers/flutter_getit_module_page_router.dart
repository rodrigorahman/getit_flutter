import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../middleware/flutter_get_it_middleware.dart';

typedef WidgetBuilderAsync = Widget Function(
  BuildContext context,
  bool isReady,
  Widget? loader,
);

class FlutterGetItPageRouter {
  final String name;
  final WidgetBuilder? builder;
  final WidgetBuilderAsync? builderAsync;
  final List<Bind> bindings;
  final List<FlutterGetItPageRouter> pages;
  final List<FlutterGetItMiddleware> middlewares;

  FlutterGetItPageRouter({
    required this.name,
    this.builder,
    this.builderAsync,
    this.bindings = const [],
    this.pages = const [],
    this.middlewares = const [],
  });

  FlutterGetItPageRouter copyWith({
    String? name,
    WidgetBuilder? builder,
    WidgetBuilderAsync? builderAsync,
    List<Bind>? bindings,
    List<FlutterGetItPageRouter>? pages,
    List<FlutterGetItMiddleware>? middlewares,
  }) {
    return FlutterGetItPageRouter(
      name: name ?? this.name,
      builder: builder ?? this.builder,
      bindings: bindings ?? this.bindings,
      pages: pages ?? this.pages,
      middlewares: middlewares ?? this.middlewares,
    );
  }
}

class FlutterGetItModuleRouter extends FlutterGetItPageRouter {
  final void Function(Injector i)? onDispose;
  final void Function(Injector i)? onInit;

  FlutterGetItModuleRouter({
    required super.name,
    super.bindings = const [],
    super.pages = const [],
    super.middlewares = const [],
    this.onDispose,
    this.onInit,
  }) : super(
          builder: (context) => const SizedBox.shrink(),
          builderAsync: (context, isReady, loader) => const SizedBox.shrink(),
        );

  @override
  FlutterGetItModuleRouter copyWith({
    String? name,
    WidgetBuilder? builder,
    WidgetBuilderAsync? builderAsync,
    List<Bind>? bindings,
    List<FlutterGetItMiddleware>? middlewares,
    List<FlutterGetItPageRouter>? pages,
    void Function(Injector i)? onDispose,
    void Function(Injector i)? onInit,
  }) {
    return FlutterGetItModuleRouter(
      name: name ?? this.name,
      bindings: bindings ?? this.bindings,
      pages: pages ?? this.pages,
      onDispose: onDispose ?? this.onDispose,
      onInit: onInit ?? this.onInit,
      middlewares: middlewares ?? this.middlewares,
    );
  }
}

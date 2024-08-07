import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

class FlutterGetItPageRouter {
  final String name;
  final WidgetBuilder page;
  final List<Bind> bindings;
  final List<FlutterGetItPageRouter> pages;

  FlutterGetItPageRouter({
    required this.name,
    required this.page,
    this.bindings = const [],
    this.pages = const [],
  });

  FlutterGetItPageRouter copyWith({
    String? name,
    WidgetBuilder? page,
    List<Bind>? bindings,
    List<FlutterGetItPageRouter>? pages,
  }) {
    return FlutterGetItPageRouter(
      name: name ?? this.name,
      page: page ?? this.page,
      bindings: bindings ?? this.bindings,
      pages: pages ?? this.pages,
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
    this.onDispose,
    this.onInit,
  }) : super(
          page: (context) => const SizedBox.shrink(),
        );

  @override
  FlutterGetItModuleRouter copyWith({
    String? name,
    WidgetBuilder? page,
    List<Bind>? bindings,
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
    );
  }
}

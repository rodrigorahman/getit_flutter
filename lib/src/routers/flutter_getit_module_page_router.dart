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
  final void Function(Injector i)? onClose;
  final void Function(Injector i)? onInit;

  FlutterGetItModuleRouter({
    required super.name,
    super.bindings = const [],
    super.pages = const [],
    this.onClose,
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
    void Function(Injector i)? onClose,
    void Function(Injector i)? onInit,
  }) {
    return FlutterGetItModuleRouter(
      name: name ?? this.name,
      bindings: bindings ?? this.bindings,
      pages: pages ?? this.pages,
      onClose: onClose ?? this.onClose,
      onInit: onInit ?? this.onInit,
    );
  }
}

import 'package:flutter/material.dart';

import '../../flutter_getit.dart';
import '../middleware/flutter_get_it_middleware.dart';

typedef WidgetBuilderAsync = Widget Function(
  BuildContext context,
  bool isReady,
  Widget? loader,
);

class FlutterGetItPageRouter {
  /// The name of the PageRouter.
  ///
  final String name;

  /// Use this builder if you want to create a page that is not async
  /// and you don't need to wait for the dependencies to be ready
  /// before building the page.
  ///
  /// If you need to wait for the dependencies to be ready before building the page
  /// use [builderAsync].
  ///
  /// If you need to show a loader while the dependencies are being loaded
  /// use [builderAsync] and pass a loader widget through the middleware [FlutterGetItMiddleware]
  ///
  final WidgetBuilder? builder;

  /// Use this builder if you want to create a page that is async
  /// and you need to wait for the dependencies to be ready, as [Bind.factoryAsync] or [Bind.singletonAsync] or [Bind.lazySingletonAsync]
  /// or even if you're using [Injector.arguments] you need to wait for the arguments to be ready
  /// before building the page.
  ///
  /// If you need to show a loader while the dependencies are being loaded
  /// pass a loader widget through the middleware [FlutterGetItMiddleware].
  ///
  /// If you don't need to wait for the dependencies to be ready before building the page
  /// use [builder].
  ///
  /// ```dart
  /// FlutterGetItPageRouter(
  /// name: '/Page',
  /// builderAsync: (context, isReady, loader) {
  ///  return switch (isReady) {
  ///   true => const ParamPage(),
  ///  false => loader ?? const CircularProgressIndicator(),
  /// };
  /// ```
  ///
  final WidgetBuilderAsync? builderAsync;

  /// The bindings that will be used in this page, like
  /// [Bind.factory], [Bind.singleton], [Bind.lazySingleton], [Bind.factoryAsync], [Bind.singletonAsync], [Bind.lazySingletonAsync].
  ///
  /// If you need to use the same bindings in all pages of the module
  /// use the [FlutterGetItModuleRouter.bindings].
  ///
  /// ```dart
  /// class MyModule extends FlutterGetItModule {
  ///  @override
  /// List<Bind> get bindings => [
  ///   Bind.factory((i) => MyController()),
  /// ];
  /// ....the rest of the module
  /// ```
  ///
  final List<Bind> bindings;

  /// The middlewares that will be used in this page as
  /// [FlutterGetItAsyncMiddleware] or [FlutterGetItSyncMiddleware].
  ///
  final List<FlutterGetItMiddleware> middlewares;

  FlutterGetItPageRouter({
    required this.name,
    this.builder,
    this.builderAsync,
    this.bindings = const [],
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
      middlewares: middlewares ?? this.middlewares,
    );
  }
}

class FlutterGetItModuleRouter extends FlutterGetItPageRouter {
  /// The function that will be called when the module is disposed.
  ///
  /// The module is disposed when all subPages or subModules are disposed
  /// and the module is not being used anymore.
  ///
  final void Function(Injector i)? onDispose;

  /// The function that will be called when the module is initialized.
  ///
  /// The module is initialized when some of the subPages or subModules build the module for the first time.
  ///
  final void Function(Injector i)? onInit;

  /// Here you can define the pages that will be used as subPages or subModules of this page like
  /// [FlutterGetItPageRouter] or [FlutterGetItModuleRouter].
  ///
  final List<FlutterGetItPageRouter> pages;

  FlutterGetItModuleRouter({
    /// The name of the ModuleRouter.
    ///
    required super.name,

    /// The bindings that will be used in this page, like
    /// [Bind.factory], [Bind.singleton], [Bind.lazySingleton], [Bind.factoryAsync], [Bind.singletonAsync], [Bind.lazySingletonAsync].
    ///
    /// If you need to use the same bindings in all pages of the module
    /// use the [FlutterGetItModuleRouter.bindings].
    ///
    /// ```dart
    /// class MyModule extends FlutterGetItModule {
    ///  @override
    /// List<Bind> get bindings => [
    ///   Bind.factory((i) => MyController()),
    /// ];
    /// ....the rest of the module
    /// ```
    ///
    super.bindings,

    /// The middlewares that will be used in this page as
    /// [FlutterGetItAsyncMiddleware] or [FlutterGetItSyncMiddleware].
    ///
    required this.pages,

    /// The middlewares that will be used in this page as
    /// [FlutterGetItAsyncMiddleware] or [FlutterGetItSyncMiddleware].
    ///
    super.middlewares,
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

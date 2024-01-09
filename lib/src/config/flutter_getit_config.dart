import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../core/flutter_getit_container_register.dart';
import '../core/flutter_getit_context.dart';
import '../core/navigator/flutter_getit_navigator_observer.dart';
import '../debug/debug_mode.dart';
import '../dependency_injector/binds/application_bindings.dart';
import '../routers/flutter_getit_module.dart';
import '../routers/flutter_getit_page_router_interface.dart';
import '../types/flutter_getit_typedefs.dart';

class FlutterGetIt extends StatefulWidget {
  const FlutterGetIt({
    super.key,
    required this.builder,
    this.bindingsBuilder,
    this.bindings,
    this.modules,
    this.pages,
    this.debugMode = false,
  }) : assert(
            (bindingsBuilder != null && bindings == null ||
                bindingsBuilder == null && bindings != null),
            'You must send only one of the attributes (bindingBuilder or bindings)');

  final ApplicationBuilder builder;
  final ApplicationBindingsBuilder? bindingsBuilder;
  final ApplicationBindings? bindings;
  final bool debugMode;

  /// [modules] Specifies the list of modules in your system.
  final List<FlutterGetItModule>? modules;

  /// [pages] Define the pages that will serve as named routes based on [FlutterGetItPageRoute].
  final List<FlutterGetItPageRouterInterface>? pages;

  @override
  State<FlutterGetIt> createState() => _FlutterGetItState();
}

class _FlutterGetItState extends State<FlutterGetIt> {
  late FlutterGetItNavigatorObserver observer;

  @override
  void initState() {
    super.initState();
    observer = FlutterGetItNavigatorObserver();
    final getIt = GetIt.I;
    final containerRegister = getIt.registerSingleton(
        FlutterGetItContainerRegister(debugMode: widget.debugMode));
    getIt.registerSingleton(DebugMode());
    getIt.registerLazySingleton(() => observer);
    getIt.registerLazySingleton(() => FlutterGetItContext());
    _registerAndLoadDependencies(containerRegister);
  }

  void _registerAndLoadDependencies(FlutterGetItContainerRegister register) {
    switch (widget) {
      case FlutterGetIt(bindings: ApplicationBindings(:final bindings)?):
        register
          ..register('APPLICATION', bindings())
          ..load('APPLICATION');

      case FlutterGetIt(:final bindingsBuilder?):
        register
          ..register('APPLICATION', bindingsBuilder())
          ..load('APPLICATION');
    }
  }

  Map<String, WidgetBuilder> _routes() {
    final routesMap = <String, WidgetBuilder>{};
    final FlutterGetIt(:modules, :pages) = widget;

    if (modules != null) {
      for (var module in modules) {
        for (var page in module.pages.entries) {
          var moduleRouteName = module.moduleRouteName;
          
          if(moduleRouteName != '/' && moduleRouteName.endsWith('/')){
            debugPrint('The module ($moduleRouteName) should not end with /');
            moduleRouteName = moduleRouteName.replaceFirst(RegExp(r'/$'), '');
          }
          
          var pageRouteName = page.key;
          if(!pageRouteName.startsWith(r'/')){
            debugPrint('Page ($pageRouteName) should starts with /');
            pageRouteName = '/${page.key}';
          }

          var finalRoute = '$moduleRouteName$pageRouteName';

          if(finalRoute == '$moduleRouteName/') {
            finalRoute = moduleRouteName;
          }

          routesMap[finalRoute.replaceAll(r'//', r'/')] = (_) {
            return FlutterGetItPageModule(
              module: module,
              page: page.value,
            );
          };
        }
      }
    }

    if (pages != null) {
      for (final page in pages) {
        routesMap[page.routeName] = (_) => page as StatefulWidget;
      }
    }

    return routesMap;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _routes(), observer);
  }
}

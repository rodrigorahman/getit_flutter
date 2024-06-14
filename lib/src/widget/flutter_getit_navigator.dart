import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../core/navigator/flutter_getit_navigator_observer_internal.dart';
import '../routers/flutter_getit_module.dart';
import '../routers/flutter_getit_page_router_interface.dart';
import '../types/flutter_getit_typedefs.dart';

class FlutterGetItNavigator extends StatefulWidget {
  const FlutterGetItNavigator({
    super.key,
    required this.builder,
    this.bindingsBuilder,
    this.modules,
    this.pages,
  });

  final ApplicationBuilder builder;
  final ApplicationBindingsBuilder? bindingsBuilder;

  /// [modules] Specifies the list of modules in your system.
  final List<FlutterGetItModule>? modules;

  /// [pages] Define the pages that will serve as named routes based on [FlutterGetItPageRoute].
  final List<FlutterGetItPageRouterInterface>? pages;

  @override
  State<FlutterGetItNavigator> createState() => _FlutterGetItNavigatorState();
}

class _FlutterGetItNavigatorState extends State<FlutterGetItNavigator> {
  late FlutterGetItNavigatorObserverInternal observerInternal;

  @override
  void initState() {
    final getIt = GetIt.I;
    observerInternal = FlutterGetItNavigatorObserverInternal()..init();
    final containerRegister = Injector.get<FlutterGetItContainerRegister>();
    getIt.registerLazySingleton(() => observerInternal);
    _registerAndLoadDependencies(containerRegister);
    super.initState();
  }

  void _registerAndLoadDependencies(FlutterGetItContainerRegister register) {
    switch (widget) {
      case FlutterGetItNavigator(:final bindingsBuilder?):
        final binds = bindingsBuilder();
        register
          ..register('NAVIGATOR', binds)
          ..load('NAVIGATOR');
    }
  }

  Map<String, WidgetBuilder> _routes() {
    final routesMap = <String, WidgetBuilder>{};
    final FlutterGetItNavigator(:modules, :pages) = widget;

    if (modules != null) {
      for (var module in modules) {
        for (var page in module.pages.entries) {
          var moduleRouteName = module.moduleRouteName;

          if (moduleRouteName != '/' && moduleRouteName.endsWith('/')) {
            DebugMode.fGetItLog(
                '🚨 - ${redColor}ERROR:$whiteColor The module $yellowColor($moduleRouteName)$whiteColor should not end with /');
            moduleRouteName = moduleRouteName.replaceFirst(RegExp(r'/$'), '');
          }

          if (moduleRouteName != '/' && !moduleRouteName.startsWith('/')) {
            DebugMode.fGetItLog(
                '🚨 - ${redColor}ERROR:$whiteColor The module $yellowColor($moduleRouteName)$whiteColor should start with /');
            moduleRouteName = '/$moduleRouteName';
          }

          var pageRouteName = page.key;
          if (!pageRouteName.startsWith(r'/')) {
            DebugMode.fGetItLog(
                '🚨 - ${redColor}ERROR:$whiteColor Page $yellowColor($pageRouteName)$whiteColor should starts with /');
            pageRouteName = '/${page.key}';
          }

          var finalRoute = '$moduleRouteName$pageRouteName';

          if (finalRoute == '$moduleRouteName/') {
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
    return widget.builder(context, _routes(), observerInternal);
  }
}

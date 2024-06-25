/* import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
import '../types/flutter_getit_typedefs.dart';

enum FlutterGetItContextType {
  main('APPLICATION'),
  navigator('NAVIGATOR'),
  ;

  final String key;
  const FlutterGetItContextType(this.key);
}

class FlutterGetIt extends StatefulWidget {
  const FlutterGetIt({
    super.key,
    required this.builder,
    ApplicationBindings? bindings,
    this.modules,
    this.pages,
    bool debugMode = false,
  })  : contextType = FlutterGetItContextType.main,
        appBindings = bindings,
        appDebugMode = debugMode,
        appContextName = null;

  const FlutterGetIt.navigator({
    super.key,
    required this.builder,
    NavigatorBindings? bindings,
    String? navigatorName,
    this.modules,
    this.pages,
  })  : contextType = FlutterGetItContextType.navigator,
        appBindings = bindings,
        appDebugMode = false,
        appContextName = navigatorName;

  final ApplicationBuilder builder;
  final FlutterGetItBindings? appBindings;
  final bool appDebugMode;
  final String? appContextName;

  /// [modules] Specifies the list of modules in your system.
  final List<FlutterGetItModule>? modules;

  /// [pages] Define the pages that will serve as named routes based on [FlutterGetItPageRoute].
  final List<FlutterGetItPageRouter>? pages;

  final FlutterGetItContextType contextType;

  @override
  State<FlutterGetIt> createState() => _FlutterGetItState();
}

class _FlutterGetItState extends State<FlutterGetIt> {
  @override
  void initState() {
    _registerAndLoadDependencies();
    super.initState();
  }

  void _registerAndLoadDependencies() {
    final getIt = GetIt.I;
    var FlutterGetIt(:appBindings, :contextType, :appContextName) = widget;
    switch (contextType) {
      case FlutterGetItContextType.main:
        if (getIt.isRegistered<FlutterGetItContainerRegister>()) {
          throw Exception(
              'You can only have one instance of FlutterGetItContainerRegister.\nCheck if you are using the FlutterGetIt in the multiple locations, try FlutterGetIt.navigator and pass a "name" if necessary.');
        }
        DebugMode.fGetItLog(
            '$yellowColor💡 - Info:$whiteColor Creating $yellowColor${contextType.key}$whiteColor context.');
        final register = getIt.registerSingleton(
          FlutterGetItContainerRegister(debugMode: widget.appDebugMode),
        );
        getIt
          ..registerSingleton(DebugMode())
          ..registerLazySingleton(FlutterGetItContext.new);
        register
          ..register(contextType.key, appBindings?.bindings() ?? [])
          ..load(contextType.key);

        break;
      case FlutterGetItContextType.navigator:
        if (!getIt.isRegistered<FlutterGetItContainerRegister>()) {
          throw Exception(
              'Are you trying to use the FlutterGetIt.navigator without the FlutterGetIt in the main context? Please add the FlutterGetIt in the main');
        }
        DebugMode.fGetItLog(
            '$yellowColor💡 - Info:$whiteColor Creating $yellowColor${contextType.key}$whiteColor context.');
        final register = Injector.get<FlutterGetItContainerRegister>();
        if (register.isRegistered(contextType.key)) {
          throw Exception(
              'You can only have one instance of ${appContextName ?? contextType.key}.\nCheck if you are using the FlutterGetIt.navigator in the multiple locations, try pass a "name" to create a different context.');
        }
        register
          ..register(
              appContextName ?? contextType.key, appBindings?.bindings() ?? [])
          ..load(appContextName ?? contextType.key);
        break;
    }
  }

  Map<String, WidgetBuilder> _routes() {
    final routesMap = <String, WidgetBuilder>{};
    final FlutterGetIt(:modules, :pages) = widget;

    if (modules != null) {
      for (var module in modules) {
        for (var page in module.pages) {
          routesMap.addAll(
            recursivePage(
              module: module,
              page: page,
              lastModuleName: module.moduleRouteName,
            ),
          );
        }
      }
    }

    if (pages != null) {
      for (final pageRoute in pages) {
        routesMap[pageRoute.name] = pageRoute.page;
      }
    }

    return routesMap;
  }

  Map<String, WidgetBuilder> recursivePage({
    String lastModuleName = '',
    required FlutterGetItModule module,
    required FlutterGetItPageRouter page,
  }) {
    final routesMap = <String, WidgetBuilder>{};
    if (lastModuleName != '/' && lastModuleName.endsWith('/')) {
      DebugMode.fGetItLog(
          '🚨 - ${redColor}ERROR:$whiteColor The module $yellowColor($lastModuleName)$whiteColor should not end with /');
      lastModuleName = lastModuleName.replaceFirst(RegExp(r'/$'), '');
    }

    if (lastModuleName != '/' && !lastModuleName.startsWith('/')) {
      DebugMode.fGetItLog(
          '🚨 - ${redColor}ERROR:$whiteColor The module $yellowColor($lastModuleName)$whiteColor should start with /');
      lastModuleName = '/$lastModuleName';
    }

    var pageRouteName = page.name;
    if (!pageRouteName.startsWith(r'/')) {
      DebugMode.fGetItLog(
          '🚨 - ${redColor}ERROR:$whiteColor Page $yellowColor($pageRouteName)$whiteColor should starts with /');
      pageRouteName = '/${page.name}';
    }

    var finalRoute = '$lastModuleName$pageRouteName';

    if (page.pages.isNotEmpty) {
      for (final page in page.pages) {
        routesMap.addAll(
          recursivePage(
            lastModuleName: finalRoute,
            module: module,
            page: page,
          ),
        );
      }
    }

    routesMap[finalRoute.replaceAll(r'//', r'/')] = (_) {
      return FlutterGetItPageModule(
        module: module,
        page: page,
      );
    };
    return routesMap;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _routes(),
    );
  }
}
 */
import 'dart:developer';

import '../../../flutter_getit.dart';

typedef FGetItLogColor = ({
  String cyan,
  String red,
  String green,
  String white,
  String yellow,
  String blue,
});

class FGetItLoggerConfig {
  bool colored;
  bool enable;
  bool gettingInstance;
  bool gettingAsyncInstance;
  bool allReady;
  bool disposeInstance;
  bool registerInstance;
  bool disposingInstance;
  bool enterAndExitModule;
  bool enterAndExitWidget;

  FGetItLoggerConfig({
    this.colored = true,
    this.enable = true,
    this.gettingInstance = true,
    this.gettingAsyncInstance = true,
    this.allReady = true,
    this.disposeInstance = true,
    this.registerInstance = true,
    this.disposingInstance = true,
    this.enterAndExitModule = true,
    this.enterAndExitWidget = true,
  });
}

final class FGetItLogger {
  static const _logName = 'FGetIt';
  static late FGetItLoggerConfig _config;
  static int logCount = 0;
  static late List<Type> _applicationMiddlewares;
  static const FGetItLogColor _colors = (
    cyan: '\x1b[36m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    white: '\x1b[37m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
  );

  FGetItLogger(FGetItLoggerConfig s, List<Type> applicationMiddlewares) {
    _config = s;
    _applicationMiddlewares = applicationMiddlewares;
  }

  static String get _cyanColor => _config.colored ? _colors.cyan : '';
  static String get _redColor => _config.colored ? _colors.red : '';
  static String get _greenColor => _config.colored ? _colors.green : '';
  static String get _whiteColor => _config.colored ? _colors.white : '';
  static String get _yellowColor => _config.colored ? _colors.yellow : '';
  static String get _blueColor => _config.colored ? _colors.blue : '';

  static String _factoryLog(String? factoryTag) {
    return factoryTag != null
        ? '$_yellowColor and FactoryTag:$_cyanColor $factoryTag'
        : '';
  }

  static logWaitingAsyncByModule(String moduleName) {
    if (_config.enable && _config.allReady) {
      _log(
        '🥱$_yellowColor Waiting complete all asynchronously dependencies on ${moduleName.replaceAll('-module', '')}',
      );
    }
  }

  static logAsyncDependenceComplete(String name, String routeName) {
    if (_config.enable && _config.allReady) {
      _log(
        '✅$_cyanColor $name was completed on ${routeName.replaceAll('-module', '')}',
      );
    }
  }

  static logAsyncDependenceFail(String name, String routeName) {
    if (_config.enable && _config.allReady) {
      _log(
        '🚨$_cyanColor $name$_redColor fail on ${routeName.replaceAll('-module', '')}$_cyanColor - calling "onFail"',
      );
    }
  }

  static logWaitingAsyncByModuleCompleted(String moduleName) {
    if (_config.enable && _config.allReady) {
      _log(
        '😎$_greenColor All asynchronously dependencies on ${moduleName.replaceAll('-module', '')} was completed',
      );
    }
  }

  static String _tagLog(String? tag) {
    return (tag != null && tag.isNotEmpty)
        ? '$_yellowColor with tag:$_cyanColor $tag'
        : ' NO TAG';
  }

  static logGettingInstance<T>({String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingInstance) {
      _log(
        '🎣$_cyanColor Getting: $T $T${_tagLog(tag)}${_factoryLog(factoryTag)}',
      );
    }
  }

  static void _log(String message) {
    log(
      message,
      name: _logName,
      level: logCount,
    );

    logCount++;
  }

  static logErrorInGetInstance<T>(String message,
      {String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingInstance) {
      _log(
        '⛔️$_redColor Error on get: $T\n$_yellowColor$message${_tagLog(tag)}${_factoryLog(factoryTag)}',
      );
    }
  }

  static logGettingAsyncInstance<T>({String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingAsyncInstance) {
      _log(
        '🎣 🥱$_yellowColor Getting async: $T${_tagLog(tag)}${_factoryLog(factoryTag)}',
      );
    }
  }

  static logErrorInGetAsyncInstance<T>(String message,
      {String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingInstance) {
      _log(
        '⛔️$_redColor Error on get async: $T\n$_yellowColor$message${_tagLog(tag)}${_factoryLog(factoryTag)}',
      );
    }
  }

  static logWaitingAllReady() {
    if (_config.enable && _config.allReady) {
      _log(
        '🥱$_yellowColor Waiting complete all asynchronously singletons',
      );
    }
  }

  static logWaitingAllReadyCompleted() {
    if (_config.enable && _config.allReady) {
      _log(
        '😎$_greenColor All asynchronously singletons complete',
      );
    }
  }

  static logAsyncInstanceReady<T>({String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingAsyncInstance) {
      _log(
        '🎣 😎$_greenColor $T${_tagLog(tag)}${_factoryLog(factoryTag)} ready',
      );
    }
  }

  static logErrorModuleShouldStartWithSlash(String moduleName) {
    if (_config.enable) {
      _log(
        '🚨 - $_redColor ERROR:$_whiteColor The module $_yellowColor(${moduleName.replaceAll('-module', '')})$_whiteColor should start with /',
      );
    }
  }

  static logCreatingContext(String contextName) {
    if (_config.enable) {
      _log(
        '🎨 - $_cyanColor Creating context: $contextName',
      );
    }
  }

  static logTryUnregisterBingWithKeepAlive<T>(
      {String? tag, String? factoryTag}) {
    if (_config.enable) {
      _log(
        '🚧$_yellowColor Info:$_whiteColor $T - ${_tagLog(tag)}${_factoryLog(factoryTag)} $_yellowColor is$_whiteColor permanent,$_yellowColor and can\'t be disposed.',
      );
    }
  }

  static logDisposeInstance<T>(Bind bind) {
    if (_config.enable && _config.registerInstance) {
      _log(
        '🚮$_yellowColor Dispose: $T (${bind.type.name}) - ${_tagLog(bind.tag)}',
      );
    }
  }

  static void logInstanceAlreadyRegistered<T>(Bind bind) {
    if (_config.enable && _config.registerInstance) {
      _log(
        '| 🎣 $_yellowColor$T (${bind.type.name}) -${_tagLog(bind.tag)}\n| 🚨$_redColor Already registered on $_redColor[ ${bind.fullNameOfModuleRegister} ]',
      );
      logMidDivider();
    }
  }

  static logRegisteringInstance<T>(Bind bind) {
    if (_config.enable && _config.registerInstance) {
      _log(
        '| 📠$_blueColor Registering: $T$_yellowColor as$_blueColor ${bind.type.name}${bind.keepAlive ? '$_yellowColor with$_blueColor keepAlive' : ''}${_tagLog(bind.tag)}',
      );
    }
  }

  static logUnregisterFactory<T>(String factoryTag, String hashCode) {
    if (_config.enable && _config.disposingInstance) {
      _log(
        '| 🚮$_yellowColor Dispose: $T -$_blueColor as (Factory child)$_yellowColor - $hashCode - FactoryTag: $factoryTag',
      );
    }
  }

  static logEnterOnWidget(String id) {
    if (_config.enable && _config.enterAndExitWidget) {
      _log(
        '🚮$_yellowColor Enter on Widget: $id - calling "onInit()"',
      );
    }
  }

  static logDisposeWidget(String id) {
    if (_config.enable && _config.enterAndExitWidget) {
      _log(
        '🚮$_yellowColor Disposing Widget: $id - calling "onDispose()"',
      );
    }
  }

  static logEnterOnModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      _log(
        '🛣️$_yellowColor Entering Module: ${moduleName.replaceAll('-module', '')} - calling $_yellowColor"onInit()"',
      );
    }
  }

  static logEnterOnSubModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      _log(
        '🛣️$_yellowColor Entering Sub-Module: ${moduleName.replaceAll('-module', '')} - calling $_yellowColor"onInit()"',
      );
    }
  }

  static logDisposeModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      _log(
        '🛣️$_yellowColor Exiting Module: ${moduleName.replaceAll('-module', '')} - calling $_yellowColor"onDispose()"',
      );
    }
  }

  static void logMidDivider() {
    if (_config.enable) {
      _log('$_yellowColor|-----------------------------------\n');
    }
  }

  static logDisposeSubModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      _log(
        '🛣️$_yellowColor Exiting Sub-Module: ${moduleName.replaceAll('-module', '')} - calling $_yellowColor"onDispose()"',
      );
    }
  }

  static void logCantUnregisteringInstance<T>(Bind bind) {
    if (_config.enable) {
      _log(
        '| 🚮$_yellowColor Dispose unavailable for $T (${bind.type.name}) - ${_tagLog(bind.tag)}\n| 🚨$_redColor Listeners$_redColor [ ${bind.listeners.join(' || ')} ]',
      );
    }
  }

  static void logNavigationTo(FlutterGetItRouteBase route) {
    if (_config.enable) {
      _log(
          '${_initDivider(color: _yellowColor)}| 🛣️$_yellowColor Navigating to: ${route.fullPath}\n| Bindings: [ ${route.binds.map((e) => e.runtimeType.toString()).join(' || ')} ]\n| Middlewares: [ ${route.middlewares.map((e) => e.runtimeType.toString()).join(' || ')} ]\n| Application Middlewares: [ ${_applicationMiddlewares.map((e) => e).join(' || ')} ]${_endDivider(color: _yellowColor)}');
    }
  }

  static String _initDivider({String? color}) {
    return '${color ?? _yellowColor}-----------------------------------\n';
  }

  static String _endDivider({String? color}) {
    return '\n${color ?? _yellowColor}-----------------------------------';
  }

  static void logInitDivider() {
    if (_config.enable) {
      _log('/${_initDivider(color: _yellowColor)}');
    }
  }

  static void logEndDivider() {
    if (_config.enable) {
      _log(_endDivider(color: _yellowColor).replaceAll('\n', '\\'));
    }
  }

  static void logInitMiddleware(String origin) {
    if (_config.enable) {
      _log(
          '/${_initDivider(color: _yellowColor)}| ⏳$_yellowColor Init middlewares by: $origin');
    }
  }

  static void logRunningMiddleware(String middleware) {
    if (_config.enable) {
      _log('| ⏰$_yellowColor Running: $middleware');
    }
  }

  static void logMiddlewareSuccess(String middleware) {
    if (_config.enable) {
      _log('| ✅$_greenColor Completed: $middleware');
    }
  }

  static void logMiddlewareFail(String middleware) {
    if (_config.enable) {
      _log('| 🚨$_redColor Fail: $middleware');
    }
  }

  static void logMiddlewareSkipped(String middleware) {
    if (_config.enable) {
      _log('\n| ⏩$_yellowColor Skipped: $middleware');
    }
  }

  static void logSolvingAsyncDependenciesFor(String fullName) {
    if (_config.enable) {
      _log('| ⏰$_yellowColor Solving async dependencies for: $fullName');
    }
  }

  static void logSolvingAsyncDependenciesCompleted(String fullName) {
    if (_config.enable) {
      _log('| ✅$_greenColor Complete async dependencies for: $fullName');
    }
  }

  static void logInformThatTheNewRouteIsAsync(String path, String origin) {
    if (_config.enable) {
      _log(
          '| ⏰$_yellowColor The navigation to "$path" will be async, because we detected: $origin');
    }
  }

  static void logInformThatTheNewRouteIsSync(String path) {
    if (_config.enable) {
      _log(
          '| ⏰$_yellowColor The navigation to "$path" will be sync, we don\'t detected any AsyncMiddleware or AsyncBinds');
    }
  }

  static void logInitInitialRoute() {
    if (_config.enable) {
      _log(
          '| ⏰$_yellowColor Init initial route detected, solving async dependencies');
    }
  }

  static void logCallingDisposeRoute(String fullPath) {
    if (_config.enable) {
      _log('| 🚮$_yellowColor Calling dispose for: $fullPath');
    }
  }

  static void logRedirectingTo(String currentPath, String redirectPath) {
    if (_config.enable) {
      _log(
          '| 🔀$_redColor Attention you are trying navigate to: $_yellowColor$currentPath$_redColor define as a$_yellowColor "FlutterGetItModuleRoute"$_greenColor but we\'re redirecting to: $_yellowColor$redirectPath');
    }
  }
}

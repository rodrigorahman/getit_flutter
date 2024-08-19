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
  static const FGetItLogColor _colors = (
    cyan: '\x1b[36m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    white: '\x1b[37m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
  );

  FGetItLogger(FGetItLoggerConfig s) {
    _config = s;
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
    return tag != null ? '$_yellowColor with tag:$_cyanColor $tag' : '';
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
        '🚧$_yellowColor Attention you\'re trying to register the $T (${bind.type.name}) - ${_tagLog(bind.tag)} again.',
      );
    }
  }

  static logRegisteringInstance<T>(Bind bind) {
    if (_config.enable && _config.registerInstance) {
      _log(
        '📠$_blueColor Registering: $T$_yellowColor as$_blueColor ${bind.type.name}${bind.keepAlive ? '$_yellowColor with$_blueColor keepAlive' : ''}${_tagLog(bind.tag)}',
      );
    }
  }

  static logUnregisterFactory<T>(String factoryTag, String hashCode) {
    if (_config.enable && _config.disposingInstance) {
      _log(
        '🚮$_yellowColor Dispose: $T -$_blueColor as (Factory child)$_yellowColor - $hashCode - FactoryTag: $factoryTag',
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

  static logDisposeSubModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      _log(
        '🛣️$_yellowColor Exiting Sub-Module: ${moduleName.replaceAll('-module', '')} - calling $_yellowColor"onDispose()"',
      );
    }
  }
}

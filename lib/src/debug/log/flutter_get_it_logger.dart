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

  static String _tagLog(String? tag) {
    return tag != null ? '$_yellowColor with tag:$_cyanColor $tag' : '';
  }

  static logGettingInstance<T>(
      {required String hashCode, String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingInstance) {
      log(
        '🎣$_cyanColor Getting: $T $hashCode${_tagLog(tag)}${_factoryLog(factoryTag)}',
        name: _logName,
      );
    }
  }

  static logErrorInGetInstance<T>(String message,
      {String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingInstance) {
      log(
        '⛔️$_redColor Error on get: $T\n$_yellowColor$message${_tagLog(tag)}${_factoryLog(factoryTag)}',
        name: _logName,
      );
    }
  }

  static logGettingAsyncInstance<T>({String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingAsyncInstance) {
      log(
        '🎣 🥱$_yellowColor Getting async: $T${_tagLog(tag)}${_factoryLog(factoryTag)}',
        name: _logName,
      );
    }
  }

  static logErrorInGetAsyncInstance<T>(String message,
      {String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingInstance) {
      log(
        '⛔️$_redColor Error on get async: $T\n$_yellowColor$message${_tagLog(tag)}${_factoryLog(factoryTag)}',
        name: _logName,
      );
    }
  }

  static logWaitingAllReady() {
    if (_config.enable && _config.allReady) {
      log(
        '🥱$_yellowColor Waiting complete all asynchronously singletons',
        name: _logName,
      );
    }
  }

  static logWaitingAllReadyCompleted() {
    if (_config.enable && _config.allReady) {
      log(
        '😎$_greenColor All asynchronously singletons complete',
        name: _logName,
      );
    }
  }

  static logAsyncInstanceReady<T>({String? tag, String? factoryTag}) {
    if (_config.enable && _config.gettingAsyncInstance) {
      log(
        '🎣 😎$_greenColor $T${_tagLog(tag)}${_factoryLog(factoryTag)} ready',
        name: _logName,
      );
    }
  }

  static logErrorModuleShouldStartWithSlash(String moduleName) {
    if (_config.enable) {
      log(
        '🚨 - $_redColor ERROR:$_whiteColor The module $_yellowColor($moduleName)$_whiteColor should start with /',
        name: _logName,
      );
    }
  }

  static logCreatingContext(String contextName) {
    if (_config.enable) {
      log(
        '🎨 - $_cyanColor Creating context: $contextName',
        name: _logName,
      );
    }
  }

  static logTryUnregisterBingWithKeepAlive<T>(
      {String? tag, String? factoryTag}) {
    if (_config.enable) {
      log(
        '🚧$_yellowColor Info:$_whiteColor $T - ${T.hashCode}${_tagLog(tag)}${_factoryLog(factoryTag)} $_yellowColor is$_whiteColor permanent,$_yellowColor and can\'t be disposed.',
        name: _logName,
      );
    }
  }

  static logDisposeInstance<T>(Bind bind) {
    if (_config.enable && _config.registerInstance) {
      log(
        '🚮$_yellowColor Dispose: $T (${bind.type.name}) - ${T.hashCode}${_tagLog(bind.tag)}',
        name: _logName,
      );
    }
  }

  static logRegisteringInstance<T>(Bind bind) {
    if (_config.enable && _config.registerInstance) {
      log(
        '📠$_blueColor Registering: $T$_yellowColor as$_blueColor ${bind.type.name}${bind.keepAlive ? '$_yellowColor with$_blueColor keepAlive' : ''}${_tagLog(bind.tag)}',
        name: _logName,
      );
    }
  }

  static logUnregisterFactory<T>(String factoryTag, String hashCode) {
    if (_config.enable && _config.disposingInstance) {
      log(
        '🚮$_yellowColor Dispose: $T -$_blueColor as (Factory child)$_yellowColor - $hashCode - FactoryTag: $factoryTag',
        name: _logName,
      );
    }
  }

  static logEnterOnWidget(String id) {
    if (_config.enable && _config.enterAndExitWidget) {
      log(
        '🚮$_yellowColor Enter on Widget: $id - calling "onInit()"',
        name: _logName,
      );
    }
  }

  static logDisposeWidget(String id) {
    if (_config.enable && _config.enterAndExitWidget) {
      log(
        '🚮$_yellowColor Disposing Widget: $id - calling "onDispose()"',
        name: _logName,
      );
    }
  }

  static logEnterOnModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      log(
        '🛣️$_yellowColor Entering Module: $moduleName - calling $_yellowColor"onInit()"',
        name: _logName,
      );
    }
  }

  static logEnterOnSubModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      log(
        '🛣️$_yellowColor Entering Sub-Module: $moduleName - calling $_yellowColor"onInit()"',
        name: _logName,
      );
    }
  }

  static logDisposeModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      log(
        '🛣️$_yellowColor Exiting Module: $moduleName - calling $_yellowColor"onDispose()"',
        name: _logName,
      );
    }
  }

  static logDisposeSubModule(String moduleName) {
    if (_config.enable && _config.enterAndExitModule) {
      log(
        '🛣️$_yellowColor Exiting Sub-Module: $moduleName - calling $_yellowColor"onDispose()"',
        name: _logName,
      );
    }
  }
}

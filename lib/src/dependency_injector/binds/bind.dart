import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../../types/flutter_getit_typedefs.dart';
import '../flutter_get_it_binding_opened.dart';

enum RegisterType {
  singleton,
  lazySingleton,
  factory,
  singletonAsync,
  lazySingletonAsync,
  permanentLazySingletonAsync,
  factoryAsync,
}

final class Bind<T extends Object> {
  late final BindRegister<T> bindRegister;
  late final BindAsyncRegister<T> bindAsyncRegister;
  final RegisterType type;
  final bool keepAlive;

  Bind._(this.bindRegister, this.type, this.keepAlive);

  Bind._async(this.bindAsyncRegister, this.type, this.keepAlive);

  String get bindingClassName => T.toString();

  static Bind singleton<T extends Object>(
    BindRegister<T> bindRegister, {
    bool keepAlive = false,
  }) =>
      Bind<T>._(
        bindRegister,
        RegisterType.singleton,
        keepAlive,
      );

  static Bind lazySingleton<T extends Object>(
    BindRegister<T> bindRegister, {
    bool keepAlive = false,
  }) =>
      Bind<T>._(
        bindRegister,
        RegisterType.lazySingleton,
        keepAlive,
      );

  static Bind factory<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(
        bindRegister,
        RegisterType.factory,
        false,
      );

  static Bind singletonAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    bool keepAlive = false,
  }) =>
      Bind<T>._async(
        bindAsyncRegister,
        RegisterType.singletonAsync,
        keepAlive,
      );

  static Bind lazySingletonAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    bool keepAlive = false,
  }) =>
      Bind<T>._async(
        bindAsyncRegister,
        RegisterType.lazySingletonAsync,
        keepAlive,
      );

  static Bind factoryAsync<T extends Object>(
          BindAsyncRegister<T> bindAsyncRegister) =>
      Bind<T>._async(
        bindAsyncRegister,
        RegisterType.factoryAsync,
        false,
      );

  void load([String? tag, bool debugMode = false]) {
    final getIt = GetIt.I;
    final isRegistered = getIt.isRegistered<T>(instanceName: tag);

    if ((type != RegisterType.factoryAsync ||
            type != RegisterType.factoryAsync) &&
        isRegistered) {
      if (!keepAlive) {
        _warnThatIsAlreadyRegistered();
      }
      return;
    }
    DebugMode.fGetItLog(
        '📠$blueColor Registering: $T$yellowColor as$blueColor ${type.name}${keepAlive ? '$yellowColor with$blueColor keepAlive' : ''}');
    switch (type) {
      case RegisterType.singleton:
        getIt.registerSingleton<T>(
          bindRegister(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.lazySingleton:
        getIt.registerLazySingleton<T>(
          () => bindRegister(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.singletonAsync:
        getIt.registerSingletonAsync<T>(
          () async => await bindAsyncRegister(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.lazySingletonAsync:
        getIt.registerLazySingletonAsync<T>(
          () async => await bindAsyncRegister(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.permanentLazySingletonAsync:
        getIt.registerLazySingletonAsync<T>(
          () async => await bindAsyncRegister(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.factory:
        getIt.registerFactory<T>(
          () => bindRegister(Injector()),
          instanceName: tag,
        );
      case RegisterType.factoryAsync:
        getIt.registerFactoryAsync<T>(
          () async => await bindAsyncRegister(Injector()),
          instanceName: tag,
        );
    }
  }

  void _warnThatIsAlreadyRegistered() {
    DebugMode.fGetItLog(
        '🚧$redColor Warning:$whiteColor $T - ${T.hashCode}$yellowColor is already registered as$blueColor ${type.name}.');
  }

  FutureOr<void> unload([String? tag, bool debugMode = false]) async {
    if (keepAlive) {
      DebugMode.fGetItLog(
          '🚧$yellowColor Info:$whiteColor $T - ${T.hashCode}$yellowColor is$whiteColor permanent,$yellowColor and can\'t be disposed.');
      return;
    }
    FlutterGetItBindingOpened.registerHashCodeOpened(T.hashCode);
    await GetIt.I.unregister<T>(
      instanceName: tag,
      disposingFunction: (entity) async {
        DebugMode.fGetItLog(
            '🚮$yellowColor Dispose: ${entity.runtimeType} - ${entity.hashCode}');

        if (hasMixin<FlutterGetItMixin>(entity)) {
          (entity as FlutterGetItMixin).dispose();
        }
        return;
      },
    );
  }

  @override
  String toString() {
    return 'Bind{bindRegister=$bindRegister, type=$type}';
  }
}

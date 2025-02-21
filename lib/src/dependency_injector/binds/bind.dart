import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../../types/flutter_getit_typedefs.dart';

enum RegisterType {
  singleton,
  singletonAsync,
  lazySingleton,
  lazySingletonAsync,
  factory,
  factoryAsync,
}

final class Bind<T extends Object> {
  final BindRegister<T>? bindRegister;
  final BindAsyncRegister<T>? bindAsyncRegister;
  final RegisterType type;
  final bool keepAlive;
  final String? tag;
  final Iterable<Type> dependsOn;
  List<String> listeners = [];
  String fullNameOfModuleRegister = '';
  bool isInitialized = false;
  Bind._(this.bindRegister, this.type, this.keepAlive, this.tag, this.dependsOn,
      this.bindAsyncRegister);

  Bind._async(
    this.bindAsyncRegister,
    this.type,
    this.keepAlive,
    this.tag,
    this.dependsOn,
    this.bindRegister,
  );

  String get bindingClassName => T.toString();

  static Bind singleton<T extends Object>(
    BindRegister<T> bindRegister, {
    bool keepAlive = false,
    String? tag,
    Iterable<Type> dependsOn = const [],
  }) =>
      Bind<T>._(
        bindRegister,
        RegisterType.singleton,
        keepAlive,
        tag,
        dependsOn,
        null,
      );

  static Bind lazySingleton<T extends Object>(
    BindRegister<T> bindRegister, {
    bool keepAlive = false,
    String? tag,
  }) =>
      Bind<T>._(
        bindRegister,
        RegisterType.lazySingleton,
        keepAlive,
        tag,
        [],
        null,
      );

  static Bind factory<T extends Object>(
    BindRegister<T> bindRegister, {
    String? tag,
  }) =>
      Bind<T>._(
        bindRegister,
        RegisterType.factory,
        false,
        tag,
        [],
        null,
      );

  static Bind singletonAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    bool keepAlive = false,
    String? tag,
    Iterable<Type> dependsOn = const [],
  }) =>
      Bind<T>._async(
        bindAsyncRegister,
        RegisterType.singletonAsync,
        keepAlive,
        tag,
        dependsOn,
        null,
      );

  static Bind lazySingletonAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    bool keepAlive = false,
    String? tag,
  }) =>
      Bind<T>._async(
        bindAsyncRegister,
        RegisterType.lazySingletonAsync,
        keepAlive,
        tag,
        [],
        null,
      );

  static Bind factoryAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    String? tag,
  }) =>
      Bind<T>._async(
        bindAsyncRegister,
        RegisterType.factoryAsync,
        false,
        tag,
        [],
        null,
      );

  void unRegister(String fullNameOfModuleListener) {
    final bind = GetIt.I.get<Bind<T>>(instanceName: tag);
    bind.listeners.remove(fullNameOfModuleListener);
    if (keepAlive) {
      FGetItLogger.logTryUnregisterBingWithKeepAlive<T>();
      return;
    }

    if (bind.listeners.isEmpty) {
      FGetItLogger.logDisposeInstance<T>(this);
      GetIt.I.unregister<T>(
        instanceName: tag,
        disposingFunction: (entity) async {
          if (itIs<FlutterGetItController>(entity)) {
            (entity as FlutterGetItController).onDispose();
          }
          isInitialized = false;
        },
      );
      GetIt.I.unregister<Bind<T>>(instanceName: tag);
    } else {
      FGetItLogger.logCantUnregisteringInstance<T>(this);
    }
    FGetItLogger.logMidDivider();

    return;
  }

  T getInstance() {
    isInitialized = true;
    return GetIt.I.get<T>(instanceName: tag);
  }

  void register(String fullNameOfModule) {
    final getIt = GetIt.I;
    final isRegistered = getIt.isRegistered<T>(instanceName: tag);

    if (isRegistered) {
      final bind = getIt.get<Bind<T>>(instanceName: tag);
      bind.listeners.add(fullNameOfModule);
      FGetItLogger.logInstanceAlreadyRegistered<T>(this);
      return;
    }

    this.listeners.add(fullNameOfModule);
    this.fullNameOfModuleRegister = fullNameOfModule;
    FGetItLogger.logRegisteringInstance<T>(this);
    getIt.registerSingleton<Bind<T>>(this, instanceName: tag);
    switch (type) {
      case RegisterType.singleton:
        if (dependsOn.isEmpty) {
          getIt.registerSingleton<T>(
            bindRegister!(FGetIt()),
            instanceName: tag,
            dispose: (entity) => null,
            signalsReady: false,
          );
        } else {
          getIt.registerSingletonWithDependencies<T>(
            () => bindRegister!(FGetIt()),
            instanceName: tag,
            dispose: (entity) => null,
            dependsOn: dependsOn,
            signalsReady: false,
          );
        }
      case RegisterType.lazySingleton:
        getIt.registerLazySingleton<T>(
          () => bindRegister!(FGetIt()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.singletonAsync:
        getIt.registerSingletonAsync<T>(
          () async => await bindAsyncRegister!(FGetIt()),
          instanceName: tag,
          dispose: (entity) => null,
          dependsOn: dependsOn,
          signalsReady: false,
        );
      case RegisterType.lazySingletonAsync:
        getIt.registerLazySingletonAsync<T>(
          () async => await bindAsyncRegister!(FGetIt()),
          instanceName: tag,
          dispose: (entity) => null,
        );

      case RegisterType.factory:
        getIt.registerFactory<T>(
          () => bindRegister!(FGetIt()),
          instanceName: tag,
        );
      case RegisterType.factoryAsync:
        getIt.registerFactoryAsync<T>(
          () async => await bindAsyncRegister!(FGetIt()),
          instanceName: tag,
        );
    }

    return;
  }

  @override
  String toString() {
    return 'Bind{bindRegister=$bindRegister, type=$type}';
  }
}

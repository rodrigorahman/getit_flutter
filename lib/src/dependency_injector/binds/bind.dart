import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../../types/flutter_getit_typedefs.dart';

enum RegisterType {
  singleton,
  lazySingleton,
  factory,
  singletonAsync,
  lazySingletonAsync,
  factoryAsync,
}

final class Bind<T extends Object> {
  late BindRegister<T> bindRegister;
  late BindAsyncRegister<T> bindAsyncRegister;
  RegisterType type;

  Bind._(
    this.bindRegister,
    this.type,
  );

  Bind._async(
    this.bindAsyncRegister,
    this.type,
  );

  String get bindingClassName => T.toString();

  static Bind singleton<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, RegisterType.singleton);

  static Bind lazySingleton<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, RegisterType.lazySingleton);

  static Bind factory<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, RegisterType.factory);

  static Bind singletonAsync<T extends Object>(
          BindAsyncRegister<T> bindAsyncRegister) =>
      Bind<T>._async(bindAsyncRegister, RegisterType.singletonAsync);

  static Bind lazySingletonAsync<T extends Object>(
          BindAsyncRegister<T> bindAsyncRegister) =>
      Bind<T>._async(bindAsyncRegister, RegisterType.lazySingletonAsync);

  static Bind factoryAsync<T extends Object>(
          BindAsyncRegister<T> bindAsyncRegister) =>
      Bind<T>._async(bindAsyncRegister, RegisterType.factoryAsync);

  void load([String? tag, bool debugMode = false]) {
    final getIt = GetIt.I;
    if (debugMode) {
      debugPrint(
          '📠$blueColor Registering: $T$yellowColor as$blueColor ${type.name}');
    }
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
      case RegisterType.factory:
        getIt.registerFactory<T>(
          () => bindRegister(Injector()),
          instanceName: tag,
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
      case RegisterType.factoryAsync:
        getIt.registerFactoryAsync<T>(
          () async => await bindAsyncRegister(Injector()),
          instanceName: tag,
        );
    }
  }

  void unload([String? tag, bool debugMode = false]) {
    GetIt.I.unregister<T>(
      instanceName: tag,
      disposingFunction: (entity) async {
        if (debugMode) {
          debugPrint(
              '🚮$yellowColor Dispose: ${entity.runtimeType} - ${entity.hashCode}');
        }
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

import 'package:get_it/get_it.dart';

import '../../../flutter_getit.dart';
import '../../types/flutter_getit_typedefs.dart';
import '../flutter_get_it_binding_opened.dart';

enum RegisterType {
  singleton,
  singletonAsync,
  lazySingleton,
  lazySingletonAsync,
  factory,
  factoryAsync,
}

final class Bind<T extends Object> {
  late final BindRegister<T> bindRegister;
  late final BindAsyncRegister<T> bindAsyncRegister;
  final RegisterType type;
  final bool keepAlive;
  bool isTheFactoryDad;
  final String? tag;

  Bind._(this.bindRegister, this.type, this.keepAlive, this.tag,
      this.isTheFactoryDad);

  Bind._async(this.bindAsyncRegister, this.type, this.keepAlive, this.tag,
      this.isTheFactoryDad);

  String get bindingClassName => T.toString();

  static Bind singleton<T extends Object>(
    BindRegister<T> bindRegister, {
    bool keepAlive = false,
    String? tag,
  }) =>
      Bind<T>._(bindRegister, RegisterType.singleton, keepAlive, tag, false);

  static Bind lazySingleton<T extends Object>(
    BindRegister<T> bindRegister, {
    bool keepAlive = false,
    String? tag,
  }) =>
      Bind<T>._(
          bindRegister, RegisterType.lazySingleton, keepAlive, tag, false);

  static Bind factory<T extends Object>(
    BindRegister<T> bindRegister, {
    String? tag,
  }) =>
      Bind<T>._(bindRegister, RegisterType.factory, false, tag, false);

  static Bind singletonAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    bool keepAlive = false,
    String? tag,
  }) =>
      Bind<T>._async(bindAsyncRegister, RegisterType.singletonAsync, keepAlive,
          tag, false);

  static Bind lazySingletonAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    bool keepAlive = false,
    String? tag,
  }) =>
      Bind<T>._async(bindAsyncRegister, RegisterType.lazySingletonAsync,
          keepAlive, tag, false);

  static Bind factoryAsync<T extends Object>(
    BindAsyncRegister<T> bindAsyncRegister, {
    String? tag,
  }) =>
      Bind<T>._async(
          bindAsyncRegister, RegisterType.factoryAsync, false, tag, false);

  bool load([String? tag, bool debugMode = false]) {
    final getIt = GetIt.I;
    final isRegistered = getIt.isRegistered<T>(instanceName: tag);

    if (isRegistered) {
      return false;
    }
    DebugMode.fGetItLog(
        '📠$blueColor Registering: $T$yellowColor as$blueColor ${type.name}${keepAlive ? '$yellowColor with$blueColor keepAlive' : ''}${tag == null ? '' : '$yellowColor and tag:$blueColor $tag'}');
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

      case RegisterType.factory:
        FlutterGetItBindingOpened.registerFactoryDad<T>();
        isTheFactoryDad = true;
        getIt.registerFactory<T>(
          () => bindRegister(Injector()),
          instanceName: tag,
        );
      case RegisterType.factoryAsync:
        FlutterGetItBindingOpened.registerFactoryDad<T>();
        isTheFactoryDad = true;
        getIt.registerFactoryAsync<T>(
          () async => await bindAsyncRegister(Injector()),
          instanceName: tag,
        );
    }
    return true;
  }

  void unload([String? tag, bool debugMode = false]) {
    if (keepAlive) {
      DebugMode.fGetItLog(
          '🚧$yellowColor Info:$whiteColor $T - ${T.hashCode}$yellowColor is$whiteColor permanent,$yellowColor and can\'t be disposed.');
      return;
    }
    FlutterGetItBindingOpened.unRegisterHashCodeOpened(T.hashCode);

    final isRegistered = GetIt.I.isRegistered<T>(instanceName: tag);
    final isFactory =
        type == RegisterType.factory || type == RegisterType.factoryAsync;

    if (isRegistered) {
      if (isFactory && !isTheFactoryDad) {
        return;
      } else if (isFactory && isTheFactoryDad) {
        FlutterGetItBindingOpened.unRegisterFactories<T>();
      }
      bool runOnDisposingFunction = false;

      GetIt.I.unregister<T>(
        instanceName: tag,
        disposingFunction: (entity) async {
          if (hasMixin<FlutterGetItMixin>(entity)) {
            (entity as FlutterGetItMixin).onDispose();
          }
          DebugMode.fGetItLog(
              '🚮$yellowColor Dispose: $T (${type.name}) - ${entity.hashCode}');

          runOnDisposingFunction = true;
          return;
        },
      );

      if (isFactory && isTheFactoryDad || !runOnDisposingFunction) {
        DebugMode.fGetItLog(
            '🚮$yellowColor Dispose: $T (${type.name}) - ${T.hashCode}');
      }

      return;
    }
  }

  @override
  String toString() {
    return 'Bind{bindRegister=$bindRegister, type=$type}';
  }
}

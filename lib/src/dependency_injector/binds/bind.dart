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
  final BindRegister<T>? bindRegister;
  final BindAsyncRegister<T>? bindAsyncRegister;
  final RegisterType type;
  final bool keepAlive;
  final bool isTheFactoryDad;
  final String? tag;
  final Iterable<Type> dependsOn;
  final bool loaded;

  Bind._(
      this.bindRegister,
      this.type,
      this.keepAlive,
      this.tag,
      this.isTheFactoryDad,
      this.dependsOn,
      this.loaded,
      this.bindAsyncRegister);

  Bind._async(
    this.bindAsyncRegister,
    this.type,
    this.keepAlive,
    this.tag,
    this.isTheFactoryDad,
    this.dependsOn,
    this.loaded,
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
        false,
        dependsOn,
        false,
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
        false,
        [],
        false,
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
        true,
        [],
        false,
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
        false,
        dependsOn,
        false,
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
        false,
        [],
        false,
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
        true,
        [],
        false,
        null,
      );

  Bind unRegister() {
    if (keepAlive) {
      FGetItLogger.logTryUnregisterBingWithKeepAlive<T>();
      return this;
    }

    final isFactory =
        type == RegisterType.factory || type == RegisterType.factoryAsync;

    if (isFactory && !isTheFactoryDad) {
      return this;
    } else if (isFactory && isTheFactoryDad) {
      FlutterGetItBindingOpened.unRegisterFactories<T>();
    }

    FGetItLogger.logDisposeInstance<T>(this);
    GetIt.I.unregister<T>(
      instanceName: tag,
      disposingFunction: (entity) async {
        if (hasMixin<FlutterGetItMixin>(entity)) {
          (entity as FlutterGetItMixin).onDispose();
        }

        FlutterGetItBindingOpened.unRegisterHashCodeOpened(entity.hashCode);
      },
    );

    return this.copyWith(loaded: false);
  }

  Bind<T> register() {
    final getIt = GetIt.I;

    if (keepAlive && loaded) {
      return this;
    }

    FGetItLogger.logRegisteringInstance<T>(this);
    switch (type) {
      case RegisterType.singleton:
        if (dependsOn.isEmpty) {
          final obj = bindRegister!(Injector());
          if (hasMixin<FlutterGetItMixin>(obj)) {
            (obj as dynamic).onInit();
          }
          FlutterGetItBindingOpened.registerHashCodeOpened(obj.hashCode);
          getIt.registerSingleton<T>(
            obj,
            instanceName: tag,
            dispose: (entity) => null,
            signalsReady: false,
          );
        } else {
          getIt.registerSingletonWithDependencies<T>(
            () {
              final obj = bindRegister!(Injector());
              if (hasMixin<FlutterGetItMixin>(obj)) {
                (obj as dynamic).onInit();
              }
              FlutterGetItBindingOpened.registerHashCodeOpened(obj.hashCode);
              return obj;
            },
            instanceName: tag,
            dispose: (entity) => null,
            dependsOn: dependsOn,
            signalsReady: false,
          );
        }
      case RegisterType.lazySingleton:
        getIt.registerLazySingleton<T>(
          () => bindRegister!(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );
      case RegisterType.singletonAsync:
        getIt.registerSingletonAsync<T>(
          () async {
            final obj = await bindAsyncRegister!(Injector());
            if (hasMixin<FlutterGetItMixin>(obj)) {
              (obj as dynamic).onInit();
            }
            FlutterGetItBindingOpened.registerHashCodeOpened(obj.hashCode);
            return obj;
          },
          instanceName: tag,
          dispose: (entity) => null,
          dependsOn: dependsOn,
          signalsReady: false,
        );
      case RegisterType.lazySingletonAsync:
        getIt.registerLazySingletonAsync<T>(
          () async => await bindAsyncRegister!(Injector()),
          instanceName: tag,
          dispose: (entity) => null,
        );

      case RegisterType.factory:
        FlutterGetItBindingOpened.registerFactoryDad<T>();
        getIt.registerFactory<T>(
          () => bindRegister!(Injector()),
          instanceName: tag,
        );
      case RegisterType.factoryAsync:
        FlutterGetItBindingOpened.registerFactoryDad<T>();
        getIt.registerFactoryAsync<T>(
          () async => await bindAsyncRegister!(Injector()),
          instanceName: tag,
        );
    }

    return copyWith(loaded: true);
  }

  @override
  String toString() {
    return 'Bind{bindRegister=$bindRegister, type=$type}';
  }

  //copyWith method
  Bind<T> copyWith({
    BindRegister<T>? bindRegister,
    BindAsyncRegister<T>? bindAsyncRegister,
    RegisterType? type,
    bool? keepAlive,
    bool? isTheFactoryDad,
    String? tag,
    Iterable<Type>? dependsOn,
    bool? loaded,
  }) {
    return Bind<T>._(
      bindRegister ?? this.bindRegister,
      type ?? this.type,
      keepAlive ?? this.keepAlive,
      tag ?? this.tag,
      isTheFactoryDad ?? this.isTheFactoryDad,
      dependsOn ?? this.dependsOn,
      loaded ?? this.loaded,
      bindAsyncRegister ?? this.bindAsyncRegister,
    );
  }
}

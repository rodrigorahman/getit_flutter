import 'package:get_it/get_it.dart';

import '../../types/flutter_getit_typedefs.dart';
import '../injector.dart';

enum RegisterType {
  singleton,
  lazySingleton,
  factory,
}

final class Bind<T extends Object> {
  BindRegister<T> bindRegister;
  RegisterType type;

  Bind._(
    this.bindRegister,
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
  void load([String? tag]) {
    final getIt = GetIt.I;
    switch (type) {
      case RegisterType.singleton:
        getIt.registerSingleton<T>(
          bindRegister(Injector()),
          instanceName: tag,
        );
      case RegisterType.lazySingleton:
        getIt.registerLazySingleton<T>(
          () => bindRegister(Injector()),
          instanceName: tag,
        );
      case RegisterType.factory:
        getIt.registerFactory<T>(
          () => bindRegister(Injector()),
          instanceName: tag,
        );
    }
  }

  void unload([String? tag]) {
    GetIt.I.unregister<T>(instanceName: tag);
  }

  @override
  String toString() {
    return 'Bind{bindRegister=$bindRegister, type=$type}';
  }
}

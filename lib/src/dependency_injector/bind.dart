import 'package:get_it/get_it.dart';

import 'injector.dart';

typedef BindRegister<T> = T Function(Injector i);

class Bind<T extends Object> {
  BindRegister<T> bindRegister;
  bool lazyInstance;

  Bind._(
    this.bindRegister,
    this.lazyInstance,
  ) {
    if (lazyInstance) {
      GetIt.I.registerLazySingleton<T>(() => bindRegister(Injector()));
    } else {
      GetIt.I.registerSingleton<T>(bindRegister(Injector()));
    }
  }

  Bind._factory(this.bindRegister) : lazyInstance = false {
    GetIt.I.registerFactory(() => bindRegister(Injector()));
  }

  void unRegister() {
    GetIt.I.unregister<T>();
  }

  static Bind singleton<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, false);

  static Bind lazySingleton<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, true);

  static Bind factory<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._factory(bindRegister);
}

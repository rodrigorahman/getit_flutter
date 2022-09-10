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

  void unRegister() {
    GetIt.I.unregister<T>();
  }

  static Bind instance<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, false);

  static Bind lazy<T extends Object>(
    BindRegister<T> bindRegister,
  ) =>
      Bind<T>._(bindRegister, true);
}

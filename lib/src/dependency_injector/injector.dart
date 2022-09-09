import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Injector {
  T get<T extends Object>() {
    try {
      return GetIt.I.get<T>();
    } on AssertionError catch (e) {
      log(e.message.toString());
      throw Exception('${T.toString()} not found in injector}');
    }
  }

  T call<T extends Object>() => get<T>();
}

extension InjectorContext on BuildContext {
  T get<T extends Object>() => Injector().get<T>();
}

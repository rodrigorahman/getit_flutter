import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Classe responsável pelo encapsulamento da busca das instancias do GetIt
class Injector {
  /// Get para recupera a instancia do GetIt
  static T get<T extends Object>() {
    try {
      return GetIt.I.get<T>();
    } on AssertionError catch (e) {
      log(e.message.toString());
      throw Exception('${T.toString()} not found in injector}');
    }
  }

  /// Callable classe para facilitar a recuperação pela instancia e não pelo atributo de classe, podendo ser passado como parâmetro
  T call<T extends Object>() => get<T>();
}

/// Extension para adicionar o recurso do injection dentro do BuildContext
extension InjectorContext on BuildContext {
  T get<T extends Object>() => Injector.get<T>();
}

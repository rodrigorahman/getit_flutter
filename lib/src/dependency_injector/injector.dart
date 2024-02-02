import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Classe responsável pelo encapsulamento da busca das instancias do GetIt
class Injector {
  /// Get para recupera a instancia do GetIt
  static T get<T extends Object>([String? tag]) {
    try {
      return GetIt.I.get<T>(instanceName: tag);
    } on AssertionError catch (e, s) {
      log(e.message.toString());

      return Error.throwWithStackTrace(
        Exception('$T not found in injector}'),
        s,
      );
    }
  }

  /// Callable classe para facilitar a recuperação pela instancia e não pelo atributo de classe, podendo ser passado como parâmetro
  T call<T extends Object>([String? tag]) => get<T>(tag);
}

/// Extension para adicionar o recurso do injection dentro do BuildContext
extension InjectorContext on BuildContext {
  T get<T extends Object>([String? tag]) => Injector.get<T>(tag);
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';

/// Classe responsável pelo encapsulamento da busca das instancias do GetIt
class Injector {
  /// Get para recupera a instancia do GetIt
  static T get<T extends Object>([String? tag]) {
    try {
      final obj = GetIt.I.get<T>(instanceName: tag);
      if (DebugMode.isEnable &&
          !(T == FlutterGetItNavigatorObserver ||
              T == FlutterGetItContainerRegister ||
              T == FlutterGetItContext)) {
        debugPrint('🎣$cyanColor Getting: $T - ${obj.hashCode}');
      }
      if (hasMixin<FlutterGetItMixin>(obj)) {
        return (obj as dynamic)..onInit();
      }
      return obj;
    } on AssertionError catch (e) {
      log('⛔️$redColor Error on get: $T\n$yellowColor${e.message.toString()}');

      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<T> getAsync<T extends Object>([String? tag]) async {
    try {
      if (DebugMode.isEnable) {
        debugPrint('🎣🥱$yellowColor Getting async: $T');
      }
      return await GetIt.I.getAsync<T>(instanceName: tag).then((obj) {
        if (DebugMode.isEnable) {
          debugPrint('🎣😎$greenColor $T ready ${obj.hashCode}');
        }
        return obj;
      });
    } on AssertionError catch (e) {
      log('⛔️$redColor Error on get async: $T\n$yellowColor${e.message.toString()}');

      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<void> allReady() async {
    if (DebugMode.isEnable) {
      debugPrint(
          '🥱$yellowColor Waiting complete all asynchronously singletons');
    }
    await GetIt.I.allReady().then((value) {
      if (DebugMode.isEnable) {
        debugPrint('😎$greenColor All asynchronously singletons complete');
      }
    });
  }

  /// Callable classe para facilitar a recuperação pela instancia e não pelo atributo de classe, podendo ser passado como parâmetro
  T call<T extends Object>([String? tag]) => get<T>();
}

/// Extension para adicionar o recurso do injection dentro do BuildContext
extension InjectorContext on BuildContext {
  T get<T extends Object>([String? tag]) => Injector.get<T>(tag);
}

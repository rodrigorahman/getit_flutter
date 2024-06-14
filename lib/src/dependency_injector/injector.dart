import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
import 'flutter_get_it_binding_opened.dart';

/// Classe responsável pelo encapsulamento da busca das instancias do GetIt
class Injector {
  /// Get para recupera a instancia do GetIt
  static T get<T extends Object>([String? tag]) {
    try {
      final getIt = GetIt.I;
      final obj = getIt.get<T>(instanceName: tag);
      if (!(T == FlutterGetItNavigatorObserver ||
          T == FlutterGetItContainerRegister ||
          T == FlutterGetItContext)) {
        DebugMode.fGetItLog('🎣$cyanColor Getting: $T - ${obj.hashCode}');
      }

      if (hasMixin<FlutterGetItMixin>(obj) &&
          !FlutterGetItBindingOpened.contains(obj.hashCode)) {
        (obj as dynamic).onInit();
      }
      FlutterGetItBindingOpened.registerHashCodeOpened(obj.hashCode);
      return obj;
    } on AssertionError catch (e) {
      log('⛔️$redColor Error on get: $T\n$yellowColor${e.message.toString()}');

      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<T> getAsync<T extends Object>([String? tag]) async {
    try {
      DebugMode.fGetItLog('🎣🥱$yellowColor Getting async: $T');

      return await GetIt.I.getAsync<T>(instanceName: tag).then((obj) {
        DebugMode.fGetItLog('🎣😎$greenColor $T ready ${obj.hashCode}');

        return obj;
      });
    } on AssertionError catch (e) {
      log('⛔️$redColor Error on get async: $T\n$yellowColor${e.message.toString()}');

      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<void> allReady() async {
    DebugMode.fGetItLog(
        '🥱$yellowColor Waiting complete all asynchronously singletons');

    await GetIt.I.allReady().then((value) {
      DebugMode.fGetItLog(
          '😎$greenColor All asynchronously singletons complete');
    });
  }

  /// Callable classe para facilitar a recuperação pela instancia e não pelo atributo de classe, podendo ser passado como parâmetro
  T call<T extends Object>([String? tag]) => get<T>(tag);
}

/// Extension para adicionar o recurso do injection dentro do BuildContext
extension InjectorContext on BuildContext {
  T get<T extends Object>([String? tag]) => Injector.get<T>(tag);
}

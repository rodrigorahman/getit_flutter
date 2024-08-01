import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import '../core/flutter_getit_context.dart';
import 'flutter_get_it_binding_opened.dart';

/// Classe responsável pelo encapsulamento da busca das instancias do GetIt
class Injector {
  static void unRegisterFactoryByTag<T>(String factoryTag) {
    FlutterGetItBindingOpened.unRegisterFactoryByTag<T>(factoryTag);
  }

  static void unRegisterAllFactories<T>() {
    FlutterGetItBindingOpened.unRegisterFactories<T>();
  }

  /// Get para recupera a instancia do GetIt
  static T get<T extends Object>({String? tag, String? factoryTag}) {
    try {
      final getIt = GetIt.I;
      if (factoryTag != null) {
        final factoryAlreadyRegistered =
            FlutterGetItBindingOpened.containsFactoryOpenedByTag<T>(factoryTag);
        if (factoryAlreadyRegistered != null) {
          return factoryAlreadyRegistered;
        }
      }
      final obj = getIt.get<T>(instanceName: tag);
      final containsFactoryDad =
          FlutterGetItBindingOpened.containsFactoryDad<T>();
      final containsHash = FlutterGetItBindingOpened.contains(obj.hashCode);
      if (!(T == FlutterGetItContainerRegister || T == FlutterGetItContext) &&
          !containsHash) {
        DebugMode.fGetItLog('🎣$cyanColor Getting: $T - ${obj.hashCode}');
      }

      if (containsFactoryDad) {
        FlutterGetItBindingOpened.registerFactoryOpened(obj, factoryTag);
      }

      if (hasMixin<FlutterGetItMixin>(obj) && !containsHash) {
        (obj as dynamic).onInit();
      }
      FlutterGetItBindingOpened.registerHashCodeOpened(obj.hashCode);
      return obj;
    } on AssertionError catch (e) {
      log('⛔️$redColor Error on get: $T\n$yellowColor${e.message.toString()}');

      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<T> getAsync<T extends Object>(
      {String? tag, String? factoryTag}) async {
    try {
      DebugMode.fGetItLog('🎣🥱$yellowColor Getting async: $T');

      return await GetIt.I.isReady<T>(instanceName: tag).then((_) {
        DebugMode.fGetItLog('🎣😎$greenColor $T ready');

        return get<T>(tag: tag, factoryTag: factoryTag);
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
  T call<T extends Object>({String? tag, String? factoryTag}) =>
      get<T>(tag: tag, factoryTag: factoryTag);
}

/// Extension para adicionar o recurso do injection dentro do BuildContext
extension InjectorContext on BuildContext {
  T get<T extends Object>({String? tag, String? factoryTag}) =>
      Injector.get<T>(tag: tag, factoryTag: factoryTag);
}

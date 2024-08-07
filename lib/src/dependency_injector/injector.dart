import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_getit.dart';
import 'flutter_get_it_binding_opened.dart';

/// Classe responsável pelo encapsulamento da busca das instancias do GetIt
class Injector {
  static void unRegisterFactoryByTag<T>(String factoryTag) {
    FlutterGetItBindingOpened.unRegisterFactoryByTag<T>(factoryTag);
  }

  static void unRegisterAllFactories<T>() {
    FlutterGetItBindingOpened.unRegisterFactories<T>();
  }

  static bool isRegistered<T extends Object>({String? tag}) {
    return GetIt.I.isRegistered<T>(instanceName: tag);
  }

  static bool any<T extends Object>() {
    return GetIt.I.getAll<T>().isNotEmpty;
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
      if (!(T == FlutterGetItContainerRegister) && !containsHash) {
        FGetItLogger.logGettingInstance<T>(
          tag: tag,
          factoryTag: factoryTag,
        );
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
      FGetItLogger.logErrorInGetInstance<T>(
        e.toString(),
        tag: tag,
        factoryTag: factoryTag,
      );
      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<T> getAsync<T extends Object>(
      {String? tag, String? factoryTag}) async {
    try {
      FGetItLogger.logGettingAsyncInstance<T>(tag: tag, factoryTag: factoryTag);

      return await GetIt.I.isReady<T>(instanceName: tag).then((_) {
        FGetItLogger.logAsyncInstanceReady<T>(
          tag: tag,
          factoryTag: factoryTag,
        );

        return get<T>(tag: tag, factoryTag: factoryTag);
      });
    } on AssertionError catch (e) {
      FGetItLogger.logErrorInGetAsyncInstance<T>(
        e.toString(),
        tag: tag,
        factoryTag: factoryTag,
      );
      throw Exception('${T.toString()} not found in injector}');
    }
  }

  static Future<void> allReady() async {
    FGetItLogger.logWaitingAllReady();

    await GetIt.I.allReady().then((value) {
      FGetItLogger.logWaitingAllReadyCompleted();
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

  bool isRegistered<T extends Object>({String? tag}) =>
      Injector.isRegistered<T>(tag: tag);

  bool any<T extends Object>() => Injector.any<T>();
}

import '../../flutter_getit.dart';

typedef FactoryRegister = ({Object obj, String? factoryTag});

final class FlutterGetItBindingOpened {
  static final _factory = <Type, List<FactoryRegister>>{};
  static final _hashCodes = <int>[];
  static dynamic argument;
  FlutterGetItBindingOpened._();

  static bool contains(int hashCode) => _hashCodes.contains(hashCode);

  static void registerHashCodeOpened(int hashCode) {
    if (!_hashCodes.contains(hashCode)) {
      _hashCodes.addAll(
        [hashCode],
      );
    }
  }

  static void unRegisterHashCodeOpened(int hashCode) {
    if (_hashCodes.contains(hashCode)) _hashCodes.remove(hashCode);
  }

  static void registerFactoryOpened(Object factory, String? factoryTag) {
    _factory[factory.runtimeType]!.add((obj: factory, factoryTag: factoryTag));
  }

  static T? containsFactoryOpenedByTag<T>(String factoryTag) {
    if (!_factory.containsKey(T)) return null;
    return _factory[T]!
        .cast<FactoryRegister?>()
        .firstWhere(
          (element) => element?.factoryTag == factoryTag,
          orElse: () => null,
        )
        ?.obj as T?;
  }

  /* static void unRegisterFactoryOpened(Object factory) {
    final tst = _factory.containsKey(factory);
    if (_factory.containsKey(factory)) {
      _factory[factory]!.removeWhere(
        (element) {
          final isIt = element.hashCode == factory.hashCode;
          if (isIt && hasMixin<FlutterGetItMixin>(element)) {
            DebugMode.fGetItLog(
                '🚮$yellowColor Dispose: $element - ${element.hashCode}');
            (element as FlutterGetItMixin).dispose();
          }
          return isIt;
        },
      );
    }
  } */

  static void registerFactoryDad<T>() {
    if (!_factory.containsKey(T)) _factory[T] = [];
  }

  static void unRegisterFactories<T>() {
    if (_factory.containsKey(T)) {
      final childFactory = _factory.remove(T)!;
      for (var factory in childFactory) {
        FGetItLogger.logUnregisterFactory<T>(
          factory.factoryTag ?? 'No FactoryTag',
          factory.obj.hashCode.toString(),
        );
        if (hasMixin<FlutterGetItMixin>(factory.obj)) {
          (factory.obj as FlutterGetItMixin).onDispose();
        }
      }
    }
  }

  static void unRegisterFactoryByTag<T>(String factoryTag) {
    if (_factory.containsKey(T)) {
      final childFactory = _factory[T]!.cast<FactoryRegister?>().firstWhere(
            (element) => element?.factoryTag == factoryTag,
            orElse: () => null,
          );
      if (childFactory != null) {
        FGetItLogger.logUnregisterFactory<T>(
          factoryTag,
          childFactory.obj.hashCode.toString(),
        );
        if (hasMixin<FlutterGetItMixin>(childFactory.obj)) {
          (childFactory.obj as FlutterGetItMixin).onDispose();
        }
        _factory[T]!.remove(childFactory);
      }
    }
  }

  static bool containsFactoryDad<T>() {
    return _factory.containsKey(T);
  }
}

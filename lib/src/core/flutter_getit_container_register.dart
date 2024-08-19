import '../../flutter_getit.dart';
import '../middleware/flutter_get_it_middleware.dart';
import 'model/binding_register.dart';

final class FlutterGetItContainerRegister {
  FlutterGetItContainerRegister();

  /// The references that will be used in the [FlutterGetItContainerRegister].
  /// Normally used to register the references that will be used or are in use throughout the application.
  ///
  final List<RegisterModel> _references = [];

  List<FlutterGetItMiddleware> middlewares(String id) =>
      _references
          .cast<RegisterModel?>()
          .firstWhere(
            (element) => element?.id == id,
            orElse: () => null,
          )
          ?.middlewares ??
      [];

  bool _contains(String id) => _references.any((element) => element.id == id);

  /// Register a reference in the [FlutterGetItContainerRegister].
  /// Normally used to register the references that will be used or are in use throughout the application.
  /// If the reference is already registered, it will not be registered again.
  ///
  void register(
    String id,
    List<Bind> bindings, {
    List<FlutterGetItMiddleware> middleware = const [],
  }) {
    switch (_contains(id)) {
      case true:
        incrementListener(id);
        break;
      case false:
        _references.add(
          RegisterModel(
            bindings: bindings,
            id: id,
            middlewares: middleware,
          ),
        );
        break;
    }
  }

  /// Increment a listener in the reference.
  ///
  void incrementListener(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      _references[index].addListener();
    }
  }

  /// Decrement a listener in the reference.
  ///
  void decrementListener(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      _references[index].removeListener();
    }
  }

  /// Check if the reference is registered.
  ///
  bool isRegistered(String id) {
    var qntOfModuleId = 0;
    for (var register in _references) {
      if (register.id.contains(id) && register.listeners > 0) {
        qntOfModuleId++;
      }
    }
    return qntOfModuleId > 0;
  }

  /// Unregister a reference in the [FlutterGetItContainerRegister].
  /// Normally used to unregister the references that will not be used throughout the application.
  /// If the reference is not registered, it will not be unregistered.
  /// If the reference has listeners, it will not be unregistered.
  ///
  void unRegister(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      for (var bind in _references[index].bindings) {
        if (bind.loaded) {
          final indexBind = _references[index].bindings.indexOf(bind);
          _references[index].bindings[indexBind] = bind.unRegister();
        }
      }

      if (!_references[index].bindings.any(
            (element) => element.loaded,
          )) _references.removeAt(index);
    }
  }

  /// Load a reference in the [FlutterGetItContainerRegister].
  /// Normally used to load the references that will be used throughout the application.
  /// If the reference is not registered, it will not be loaded.
  ///
  void load(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      var bindsToRemoveBecauseWasRegisteredInAnotherModule = <int>[];
      for (var bind in _references[index].bindings) {
        if (!bind.loaded) {
          final indexBind = _references[index].bindings.indexOf(bind);
          final bindRegistered = bind.register();

          if (bindRegistered != null) {
            _references[index].bindings[indexBind] = bindRegistered;
          } else {
            bindsToRemoveBecauseWasRegisteredInAnotherModule.add(indexBind);
          }
        }
      }

      if (bindsToRemoveBecauseWasRegisteredInAnotherModule.isNotEmpty) {
        for (var indexBind
            in bindsToRemoveBecauseWasRegisteredInAnotherModule) {
          _references[index].bindings.removeAt(indexBind);
        }
      }
    }
  }

  List<RegisterModel> references() {
    return _references;
  }

  /// Check if the reference has any dependents.
  ///
  bool anyCoreDependents(String id) {
    var qntOfModuleId = 0;
    for (var register in _references) {
      if (register.id.startsWith(id) && (register.listeners > 0)) {
        qntOfModuleId++;
      }
    }
    return qntOfModuleId > 0;
  }
}

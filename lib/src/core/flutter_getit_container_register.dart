import '../../flutter_getit.dart';
import '../middleware/flutter_get_it_middleware.dart';
import 'model/binding_register.dart';

final class FlutterGetItContainerRegister {
  FlutterGetItContainerRegister();

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

  List<Bind<Object>> bindings(String id) =>
      _references
          .cast<RegisterModel?>()
          .firstWhere(
            (element) => element?.id == id,
            orElse: () => null,
          )
          ?.bindings ??
      [];

  bool _contains(String id) => _references.any((element) => element.id == id);

  void register(
    String id,
    List<Bind> bindings, {
    List<FlutterGetItMiddleware> middleware = const [],
  }) {
    switch (_contains(id)) {
      case true:
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

  void incrementListener(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      _references[index].addListener();
    }
  }

  void decrementListener(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      _references[index].removeListener();
    }
  }

  bool isRegistered(String id) {
    var qntOfModuleId = 0;
    for (var register in _references) {
      if (register.id.contains(id) && register.listeners > 0) {
        qntOfModuleId++;
      }
    }
    return qntOfModuleId > 0;
  }

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

  void load(String id) {
    final index = _references.indexWhere((element) => element.id == id);
    if (index != -1) {
      for (var bind in _references[index].bindings) {
        if (!bind.loaded) {
          final indexBind = _references[index].bindings.indexOf(bind);
          _references[index].bindings[indexBind] = bind.register();
        }
      }
    }
  }

  List<RegisterModel> references() {
    return _references;
  }

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

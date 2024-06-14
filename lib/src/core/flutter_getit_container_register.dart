import '../dependency_injector/binds/bind.dart';
import 'model/binding_register.dart';

final class FlutterGetItContainerRegister {
  FlutterGetItContainerRegister({this.debugMode = false});

  final Map<String, ({RegisterModel register, bool loaded})> _references = {};
  final bool debugMode;

  void register(String id, List<Bind> bindings, {bool withTag = false}) {
    if (!_references.containsKey(id)) {
      final tag = withTag ? id : null;
      _references[id] = (
        register: RegisterModel(bindings: bindings, tag: tag),
        loaded: false,
      );
    }
  }

  void unRegister(String id) {
    if (_references[id] case (:final register, loaded: true)) {
      for (final bind in register.bindings) {
        bind.unload(register.tag);
      }
    }
    _references.remove(id);
  }

  void load(String id) {
    final bindingRegister = _references[id];
    if (bindingRegister != null) {
      if (bindingRegister
          case (
            :final register,
            loaded: false,
          )) {
        for (final bind in register.bindings) {
          bind.load(register.tag);
        }
        _references[id] = (register: register, loaded: true);
      }
    } else {
      throw Exception('Register($id) not found');
    }
  }

  Map<String, ({bool loaded, RegisterModel register})> references() {
    if (debugMode) {
      return _references;
    }
    throw Exception('Debug mode not enabled');
  }
}

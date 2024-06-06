import '../../flutter_getit.dart';
import 'model/binding_register.dart';

class FlutterGetItContainerRegister {
  FlutterGetItContainerRegister({this.debugMode = false});

  final Map<String, ({RegisterModel register, bool loaded})> _references = {};
  final bool debugMode;

  void register(String id, List<Bind> bindings, {bool withTag = false}) {
    final normalBinds = bindings.where((bind) => !bind.keepAlive).toList();
    final keepAliveBinds = bindings.where((bind) => bind.keepAlive).toList();
    if (!_references.containsKey(id)) {
      final tag = withTag ? id : null;
      _references[id] = (
        register: RegisterModel(bindings: normalBinds, tag: tag),
        loaded: false
      );
    }
    if (keepAliveBinds.isNotEmpty) {
      if (_references.containsKey('APPLICATION_PERMANENT')) {
        final ref = _references.remove('APPLICATION_PERMANENT')!;
        _references['APPLICATION_PERMANENT'] = (
          register: RegisterModel(
            bindings: [...ref.register.bindings, ...keepAliveBinds],
          ),
          loaded: false,
        );
      } else {
        _references['APPLICATION_PERMANENT'] = (
          register: RegisterModel(bindings: keepAliveBinds),
          loaded: false,
        );
      }
      load('APPLICATION_PERMANENT');
    }
  }

  void unRegister(String id) {
    if (_references[id] case (:final register, loaded: true)) {
      for (var bind in register.bindings) {
        bind.unload(register.tag, debugMode);
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
        for (var bind in register.bindings) {
          bind.load(register.tag, debugMode);
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

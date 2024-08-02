import '../../flutter_getit.dart';
import '../middleware/flutter_get_it_middleware.dart';
import 'model/binding_register.dart';

final class FlutterGetItContainerRegister {
  FlutterGetItContainerRegister();

  final Map<String, ({RegisterModel register, bool loaded})> _references = {};
  List<FlutterGetItMiddleware> middlewares(String id) =>
      _references[id]?.register.middlewares ?? [];
  void register(String id, List<Bind> bindings,
      {bool withTag = false,
      List<FlutterGetItMiddleware> middleware = const []}) {
    final normalBinds = bindings.where((bind) => !bind.keepAlive).toList();
    final keepAliveBinds = bindings.where((bind) => bind.keepAlive).toList();
    if (!_references.containsKey(id)) {
      final tag = withTag ? id : null;
      _references[id] = (
        register: RegisterModel(
            bindings: normalBinds, tag: tag, middlewares: middleware),
        loaded: false,
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
    if (_references[id] case (:final register, loaded: final _)) {
      for (var bind in register.bindings) {
        bind.unload(bind.tag);
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
        var unRegistered = [];
        for (var bind in register.bindings) {
          final wasRegistered = bind.load(bind.tag);
          if (!wasRegistered) {
            unRegistered.add(bind);
          }
        }
        register.bindings.removeWhere((bind) => unRegistered.contains(bind));

        _references[id] = (
          register: register,
          loaded: true,
        );
      }
    } else {
      throw Exception('Register($id) not found');
    }
  }

  Map<String, ({bool loaded, RegisterModel register})> references() {
    return _references;
  }

  bool isRegistered(String id) {
    return _references.containsKey(id);
  }
}

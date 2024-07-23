class FlutterGetItContext {
  // Salva o modulo e sua hash quando aberto pela primeira vez
  final _modulesFirstRouteHash = <String, int>{};

  //Só adiciona se não existir, para garantir que registamos apenas a root.
  void registerId(String id) {
    if (!_modulesFirstRouteHash.containsKey(id)) {
      _modulesFirstRouteHash[id] = 1;
    } else {
      _modulesFirstRouteHash[id] = _modulesFirstRouteHash[id]! + 1;
    }
  }

  void removeId(String id) {
    if (_modulesFirstRouteHash.containsKey(id)) {
      if (_modulesFirstRouteHash[id]! > 1) {
        _modulesFirstRouteHash[id] = _modulesFirstRouteHash[id]! - 1;
      } else {
        _modulesFirstRouteHash.remove(id);
      }
    }
  }

  //Verifica se é a root page e remove, retornando true para autorizar o unregister
  bool canUnregisterCoreModule(String id) {
    var qntOfModuleId = 0;
    _modulesFirstRouteHash.map((key, value) {
      if (key.contains(id)) {
        qntOfModuleId++;
      }

      return MapEntry(key, value);
    });
    return qntOfModuleId <= 1;
  }
}

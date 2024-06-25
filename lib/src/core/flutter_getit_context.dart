class FlutterGetItContext {
  // Salva o modulo e sua hash quando aberto pela primeira vez
  final _modulesFirstRouteHash = <String, int>{};

  //Só adiciona se não existir, para garantir que registamos apenas a root.
  void registerId(String id, int hashCode) {
    if (!_modulesFirstRouteHash.containsKey(id)) {
      _modulesFirstRouteHash[id] = hashCode;
    }
  }

  bool isRegistered(String id) {
    return _modulesFirstRouteHash.containsKey(id);
  }

  //Verifica se é a root page e remove, retornando true para autorizar o unregister
  bool canUnregister(String id, int hash) {
    final isTheRootPage = _modulesFirstRouteHash[id] == hash;
    if (isTheRootPage) {
      _modulesFirstRouteHash.remove(id);
    }
    return isTheRootPage;
  }
}

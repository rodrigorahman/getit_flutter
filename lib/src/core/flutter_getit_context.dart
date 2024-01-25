class FlutterGetItContext {
  String _lastIdLoaded = '';
  String _currentIdLoaded = '';

  void registerId(String id) {
    _lastIdLoaded = _currentIdLoaded;
    _currentIdLoaded = id;
  }

  void returnToLastId() {
    final currentIdBK = _currentIdLoaded;
    _currentIdLoaded = _lastIdLoaded;
    _lastIdLoaded = currentIdBK;
  }

  bool isSameIdLoad(String id) {
    return id == _currentIdLoaded;
  }

  String get lastIdLoaded => _lastIdLoaded;
  String get currentIdLoaded => _currentIdLoaded;
}

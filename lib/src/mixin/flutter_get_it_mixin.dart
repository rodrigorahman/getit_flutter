mixin FlutterGetItMixin on Object {
  void onDispose();

  void onInit();
}

bool hasMixin<T>(Object object) {
  return object is T;
}

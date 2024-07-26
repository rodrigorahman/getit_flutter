mixin FlutterGetItMixin on Object {
  void dispose();

  void onInit();
}

bool hasMixin<T>(Object object) {
  return object is T;
}

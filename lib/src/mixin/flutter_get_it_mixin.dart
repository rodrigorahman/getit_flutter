mixin FlutterGetItMixin on Object {
  void dispose();

  void onInit();
}

bool hasMixin<T>(Object object) {
  if (object is T) {
    return true;
  }
  return false;
}

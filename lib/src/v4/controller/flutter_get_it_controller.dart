abstract class FlutterGetItController {
  FlutterGetItController() {
    onInit();
  }
  void onDispose();

  void onInit();
}

bool itIs<T>(Object object) {
  return object is T;
}

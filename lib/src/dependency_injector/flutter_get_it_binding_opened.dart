final class FlutterGetItBindingOpened {
  static final _hashCodes = <int>[];
  FlutterGetItBindingOpened._();

  static bool contains(int hashCode) => _hashCodes.contains(hashCode);

  static void registerHashCodeOpened(int hashCode) {
    if (!_hashCodes.contains(hashCode)) _hashCodes.add(hashCode);
  }

  static void unRegisterHashCodeOpened(int hashCode) {
    if (_hashCodes.contains(hashCode)) _hashCodes.remove(hashCode);
  }
}

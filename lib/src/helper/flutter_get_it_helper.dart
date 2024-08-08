sealed class FlutterGetItHelper {
  /// Two handy functions that help me to express my intention clearer and shorter to check for runtime
  /// errors
  static void throwIf(bool condition, Object error) {
    if (condition) throw error;
  }

  static void throwIfNot(bool condition, Object error) {
    if (!condition) throw error;
  }
}

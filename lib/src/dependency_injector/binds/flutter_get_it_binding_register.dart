/* import '../../../flutter_getit.dart';

final class FlutterGetItBindingRegister {
  FlutterGetItBindingRegister._();

  /// This method simplifies the registration of permanent bindings, removing the
  /// need to incorporate them into the ApplicationBinding class. It ensures a
  /// constant application binding that remains active throughout the entire
  /// lifecycle of the application under a specific key.

  static void registerPermanentBinding(
      FlutterGetItContainerRegister container, List<Bind> bindings) {
    container
      ..register('APPLICATION_PERMANENT', bindings)
      ..load('APPLICATION_PERMANENT');
  }
}
 */
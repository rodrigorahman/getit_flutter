import '../../../flutter_getit.dart';
import '../../core/flutter_getit_container_register.dart';

final class FlutterGetItBindingRegister {
  FlutterGetItBindingRegister._();

  /// This method simplifies the registration of permanent bindings, removing the
  /// need to incorporate them into the ApplicationBinding class. It ensures a
  /// constant application binding that remains active throughout the entire
  /// lifecycle of the application under a specific key.
  static void registerPermanentBinding(String key, List<Bind> bindings) {
    final container = Injector.get<FlutterGetItContainerRegister>();
    container
      ..register(key, bindings)
      ..load(key);
  }
}

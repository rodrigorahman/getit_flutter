import '../../dependency_injector/binds/bind.dart';
import '../../middleware/flutter_get_it_middleware.dart';

final class RegisterModel {
  final List<Bind> bindings;
  final List<FlutterGetItMiddleware> middlewares;
  bool loaded = false;
  String? tag;

  RegisterModel({
    required this.bindings,
    this.middlewares = const [],
    this.tag,
  });

  @override
  String toString() {
    return 'RegisterModel{bindings=$bindings, loaded=$loaded, tag=$tag}';
  }
}

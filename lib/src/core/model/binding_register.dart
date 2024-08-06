import '../../dependency_injector/binds/bind.dart';
import '../../middleware/flutter_get_it_middleware.dart';

final class RegisterModel {
  final List<Bind> bindings;
  final List<FlutterGetItMiddleware> middlewares;
  final String id;
  int listeners;

  RegisterModel({
    required this.bindings,
    this.middlewares = const [],
    required this.id,
    this.listeners = 1,
  });

  @override
  String toString() {
    return 'RegisterModel{tag=$id,listeners=$listeners,bindings=$bindings,middlewares=$middlewares}';
  }

  void addListener() {
    listeners++;
  }

  void removeListener() {
    listeners--;
  }

  //copyWith
  RegisterModel copyWith({
    List<Bind>? bindings,
    List<FlutterGetItMiddleware>? middlewares,
    String? id,
    int? listeners,
  }) {
    return RegisterModel(
      bindings: bindings ?? this.bindings,
      middlewares: middlewares ?? this.middlewares,
      id: id ?? this.id,
      listeners: listeners ?? this.listeners,
    );
  }
}

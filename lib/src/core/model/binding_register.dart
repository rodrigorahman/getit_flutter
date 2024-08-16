import '../../dependency_injector/binds/bind.dart';
import '../../middleware/flutter_get_it_middleware.dart';

final class RegisterModel {
  /// The bindings that will be used in the context,
  /// as [Bind.factory], [Bind.singleton], [Bind.lazySingleton], [Bind.factoryAsync], [Bind.singletonAsync], [Bind.lazySingletonAsync].
  final List<Bind> bindings;

  /// The middlewares that will be used in the context as
  /// [FlutterGetItAsyncMiddleware] or [FlutterGetItSyncMiddleware].
  final List<FlutterGetItMiddleware> middlewares;

  /// The id of the context.
  final String id;

  /// The number of listeners that are using the context.
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

  /// Add a listener to the context.
  ///
  void addListener() {
    listeners++;
  }

  /// Remove a listener from the context.
  ///
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

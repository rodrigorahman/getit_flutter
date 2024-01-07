import '../../dependency_injector/binds/bind.dart';

final class RegisterModel {
  final List<Bind> bindings;
  bool loaded = false;
  String? tag;

  RegisterModel({
    required this.bindings,
    this.tag,
  });

  @override
  String toString() {
    return 'RegisterModel{bindings=$bindings, loaded=$loaded, tag=$tag}';
  }
}

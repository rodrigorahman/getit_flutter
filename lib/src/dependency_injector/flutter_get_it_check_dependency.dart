import 'package:flutter/rendering.dart';

import '../../flutter_getit.dart';

final class FlutterGetItCheckDependency {
  static void checkOnDependencies({required List<Bind<Object>> bindings}) {
    final lazySingletonAsyncDeps = bindings
        .where((bind) => bind.type == RegisterType.lazySingletonAsync)
        .map((bind) => bind.bindingClassName)
        .toSet();
    final allDependsOn = bindings
        .expand((bind) => bind.dependsOn.map((d) => d.toString()))
        .toSet();

    final dependencyProblem = lazySingletonAsyncDeps
        .firstWhere(allDependsOn.contains, orElse: () => '');
    if (dependencyProblem.isNotEmpty) {
      throw FlutterError.fromParts([
        ErrorSummary('Misuse of LazySingletonAsync'),
        ErrorDescription(
            '$dependencyProblem cannot be LazySingletonAsync when it is a dependency of another bind\n'),
        ErrorHint('Ensure all binds are correctly configured.'),
        DiagnosticsProperty<String>('Problematic Binding', dependencyProblem,
            style: DiagnosticsTreeStyle.errorProperty),
        DiagnosticsProperty<String>(
            'Recommendation', 'Change $dependencyProblem to SingletonAsync',
            style: DiagnosticsTreeStyle.errorProperty),
      ]);
    }
  }
}

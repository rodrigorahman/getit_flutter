import 'package:flutter/widgets.dart';
import 'package:flutter_getit/src/core/flutter_getit_core.dart';
import 'package:flutter_getit/src/core/typedefs.dart';

import '../../flutter_getit.dart';

class FlutterGetItPageBuilder extends FlutterGetitCore {
  /// Informe a pagina que deve ser carregada
  final WidgetBuilder page;

  /// Informe os bindings que devem ser carregados e descartados
  final BindBuilder binding;

  const FlutterGetItPageBuilder({
    super.key,
    required this.page,
    required this.binding,
  });

  @override
  WidgetBuilder get view => page;

  @override
  List<Bind> get injections => [binding()];
}

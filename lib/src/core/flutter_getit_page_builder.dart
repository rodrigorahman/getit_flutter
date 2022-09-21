import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_getit/src/core/flutter_getit_core.dart';

import '../../flutter_getit.dart';

typedef BindBuilder = Bind Function();

class FlutterGetItPageBuilder extends FlutterGetitCore {
  // Informe a pagina que deve ser carregada
  final WidgetBuilder page;
  // Informe os bindings que devem ser carregados e descartados
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

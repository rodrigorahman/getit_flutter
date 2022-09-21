import 'package:flutter/widgets.dart';
import 'package:flutter_getit/src/core/flutter_getit_core.dart';

import '../../flutter_getit.dart';

abstract class FlutterGetItPageRoute extends FlutterGetitCore {
  /// Getter para declaração do bindings que serão inicializados e descartados na inicialização e descarte da view
  List<Bind> get bindings => [];

  /// Getter para informar qual Page deve ser reenderizado no carregamento
  WidgetBuilder get page;

  const FlutterGetItPageRoute({
    super.key,
  });

  @override
  WidgetBuilder get view => page;

  @override
  List<Bind> get injections => bindings;
}

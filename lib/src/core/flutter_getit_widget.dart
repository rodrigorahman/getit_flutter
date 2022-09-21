import 'package:flutter/widgets.dart';
import 'package:flutter_getit/src/core/flutter_getit_core.dart';

import '../../flutter_getit.dart';

abstract class FlutterGetItWidget extends FlutterGetitCore {
  /// Getter para declaração do bindings que serão inicializados e descartados na inicialização e descarte da view
  List<Bind> get bindings => [];

  /// Getter para informar qual widget deve ser reenderizado no carregamento
  WidgetBuilder get widget;

  const FlutterGetItWidget({super.key});

  @override
  WidgetBuilder get view => widget;

  @override
  List<Bind> get injections => bindings;
}

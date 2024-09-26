class FlutterGetItRouteParamsExtractor {
  final String routePattern;
  final String actualRoute;

  FlutterGetItRouteParamsExtractor(this.routePattern, this.actualRoute);

  Map<String, String> extract() {
    final patternSegments = _splitSegments(routePattern);
    final routeSegments = _splitSegments(actualRoute);

    return _extractParams(patternSegments, routeSegments);
  }

  Map<String, String> _extractParams(
    List<String> patternSegments,
    List<String> routeSegments,
  ) {
    final Map<String, String> params = {};

    // Itera sobre os segmentos dos padrões e da rota
    for (int i = 0; i < patternSegments.length; i++) {
      final patternSegment = patternSegments[i];
      final routeSegment = routeSegments.length > i ? routeSegments[i] : null;

      if (routeSegment == null)
        break; // Se não houver mais segmentos, sair do loop

      if (_isDynamicSegment(patternSegment)) {
        final paramName = _createParamName(patternSegments, i, patternSegment);
        params[paramName] = routeSegment;
      }
    }

    return params;
  }

  String _createParamName(
      List<String> patternSegments, int index, String dynamicSegment) {
    // Obtem o segmento estático anterior ao dinâmico, ou "param" como fallback
    final previousSegment = index > 0 ? patternSegments[index - 1] : '';

    // Remove qualquer caractere especial
    final cleanSegment = previousSegment.replaceAll(RegExp(r'[^\w]'), '');

    // Cria o nome do parâmetro com base no segmento anterior e no próprio nome dinâmico
    return '${cleanSegment}_${_extractParamName(dynamicSegment)}';
  }

  List<String> _splitSegments(String path) {
    return path.split('/').where((segment) => segment.isNotEmpty).toList();
  }

  bool _isDynamicSegment(String segment) {
    return segment.startsWith(':');
  }

  String _extractParamName(String segment) {
    return segment.substring(1);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../flutter_getit.dart';

@protected
final class FlutterGetItExtension {
  final FlutterGetItContainerRegister _register;

  FlutterGetItExtension({
    required FlutterGetItContainerRegister register,
  }) : _register = register {
    registerExtension(
      'ext.br.com.academiadoflutter.flutter_getit.listAll',
      (_, parameters) async {
        final dataDefault = readyReferences();

        return ServiceExtensionResponse.result(
            jsonEncode({'data': dataDefault}));
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> readyReferences() {
    final references = _register.references();

    return references.map((key, value) {
      final bindings = value.register.bindings;
      final bindingsMap = bindings
          .map<Map<String, dynamic>>(
            (e) => {
              'className': e.bindingClassName,
              'type': e.type.name,
            },
          )
          .toList();

      return MapEntry(key, bindingsMap);
    });
  }
}

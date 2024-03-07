import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../core/flutter_getit_container_register.dart';
import '../dependency_injector/injector.dart';

class DebugMode {
  late final FlutterGetItContainerRegister _register;

  DebugMode() {
    _register = Injector.get<FlutterGetItContainerRegister>();
    registerExtension('ext.br.com.academiadoflutter.flutter_getit.listAll', (
      method,
      parameters,
    ) async {
      final data = readyReferences();
      return ServiceExtensionResponse.result(
        jsonEncode({'data': data}),
      );
    });
  }
  void printRegister() {
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(readyReferences()),
    );
  }

  Map<String, dynamic> readyReferences() {
    final references = _register.references();
    final referencesData = references.map(
      (key, value) {
        final bindings = value.register.bindings;
        final bindingsMap = bindings
            .map<Map<String, String>>(
              (e) => {
                'className': e.bindingClassName,
                'type': e.type.name,
              },
            )
            .toList();
        return MapEntry(key, bindingsMap);
      },
    );
    return referencesData;
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../core/flutter_getit_container_register.dart';
import '../dependency_injector/injector.dart';

const cyanColor = '\x1B[36m';
const redColor = '\x1B[31m';
const greenColor = '\x1B[32m';
const whiteColor = '\x1B[37m';
const yellowColor = '\x1B[33m';
const blueColor = '\x1B[34m';

class DebugMode {
  late final FlutterGetItContainerRegister _register;
  static late final bool isEnable;

  DebugMode() {
    isEnable = true;
    _register = Injector.get<FlutterGetItContainerRegister>();
    registerExtension('ext.br.com.academiadoflutter.flutter_getit.listAll',
        (method, parameters) async {
      final data = readyReferences();
      return ServiceExtensionResponse.result(jsonEncode({'data': data}));
    });
  }
  void printRegister() {
    debugPrint(const JsonEncoder.withIndent('  ').convert(readyReferences()));
  }

  Map<String, dynamic> readyReferences() {
    final references = _register.references();
    final referencesData = references.map((key, value) {
      final bindings = value.register.bindings;
      final bindingsMap = bindings
          .map<Map<String, String>>((e) => {
                'className': e.bindingClassName,
                'type': e.type.name,
              })
          .toList();
      return MapEntry(key, bindingsMap);
    });
    return referencesData;
  }
}

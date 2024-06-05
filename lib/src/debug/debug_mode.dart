import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../core/flutter_getit_container_register.dart';
import '../dependency_injector/injector.dart';

const cyanColor = '\x1b[36m';
const redColor = '\x1b[31m';
const greenColor = '\x1b[32m';
const whiteColor = '\x1b[37m';
const yellowColor = '\x1b[33m';
const blueColor = '\x1b[34m';

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
    DebugMode.fGetItLog(
      const JsonEncoder.withIndent('  ').convert(
        readyReferences(),
      ),
    );
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

  static fGetItLog(String data) {
    if (isEnable) {
      if (Platform.isIOS) {
        log(data);
      } else {
        debugPrint(data);
      }
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../core/flutter_getit_container_register.dart';
import '../dependency_injector/injector.dart';

const cyanColor = '\x1b[36m';
const redColor = '\x1b[31m';
const greenColor = '\x1b[32m';
const whiteColor = '\x1b[37m';
const yellowColor = '\x1b[33m';
const blueColor = '\x1b[34m';

final class DebugMode {
  late final FlutterGetItContainerRegister _register;
  static late final bool isEnable;

  DebugMode() {
    isEnable = true;
    _register = Injector.get<FlutterGetItContainerRegister>();
    registerExtension(
      'ext.br.com.academiadoflutter.flutter_getit.listAll',
      (_, parameters) async {
        final dataDefault = readyReferences();

        return ServiceExtensionResponse.result(
            jsonEncode({'data': dataDefault}));
      },
    );
  }
  void printRegister() {
    DebugMode.fGetItLog(
      const JsonEncoder.withIndent('  ').convert(
        readyReferences(),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> readyReferences() {
    final references = _register.references();

    return references.map((key, value) {
      final bindings = value.register.bindings;
      final bindingsMap = bindings
          .map<Map<String, dynamic>>(
            (e) => {'className': e.bindingClassName, 'type': e.type.name},
          )
          .toList();

      return MapEntry(key, bindingsMap);
    });
  }

  static fGetItLog(String data) {
    if (isEnable && !kReleaseMode) {
      log(data, name: 'FGetIt');
      /* if (Platform.isIOS) {
        log(data, name: 'FGetIt');
      } else {
        debugPrint(data);
      } */
    }
  }

  /* Map<String, dynamic> transformJson(Map<String, dynamic> json) {
    final transformed = <String, dynamic>{};

    json.forEach((key, value) {
      if (value is List) {
        // Handle lists
        transformed[key] =
            value.map((item) => transformListItem(item)).toList();
      } else if (value is Map) {
        // Handle nested objects
        transformed[key] = transformNestedObject(value as Map<String, dynamic>);
      } else {
        // Handle other data types (primitive values)
        transformed[key] = value;
      }
    });

    return transformed;
  }

  dynamic transformListItem(dynamic item) {
    if (item is Map) {
      return transformNestedObject(item as Map<String, dynamic>);
    } else {
      return item;
    }
  }

  Map<String, dynamic> transformNestedObject(Map<String, dynamic> nested) {
    final transformed = <String, dynamic>{};

    nested.forEach((key, value) {
      if (key.startsWith('/') && key.split('/').length == 2) {
        // Handle root-level route grouping with matching names
        final route = key.substring(1);
        final innerMap = <String, dynamic>{route: transformListItem(value)};
        transformed[key] = innerMap;
      } else if (key.startsWith('/')) {
        // Handle nested routes
        final parts = key.split('/');
        final parentKey = parts.sublist(0, parts.length - 1).join('/');
        if (!transformed.containsKey(parentKey)) {
          transformed[parentKey] = <String, dynamic>{};
        }
        transformed[parentKey][parts.last] = transformListItem(value);
      } else {
        // Handle non-route keys within nested objects
        transformed[key] = transformListItem(value);
      }
    });

    return transformed;
  } */
}

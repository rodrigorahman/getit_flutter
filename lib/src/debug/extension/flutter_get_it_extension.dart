import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../flutter_getit.dart';

@protected
final class FlutterGetItExtension {
  FlutterGetItExtension() {
    registerExtension(
      'ext.br.com.academiadoflutter.flutter_getit.listAll',
      (_, parameters) async {
        final dataDefault = readyReferences();

        return ServiceExtensionResponse.result(
          jsonEncode(
            {'data': dataDefault},
          ),
        );
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> readyReferences() {
    var myMap = <String, List<Map<String, dynamic>>>{};
    /* final references = _register.references();

    for (var ref in references) {
      myMap[ref.id] = <Map<String, dynamic>>[];
      for (var bind in ref.bindings) {
        myMap[ref.id]!.add(
          {
            'className': bind.bindingClassName,
            'type': bind.type.name,
            'keepAlive': bind.keepAlive.toString(),
            'loaded': bind.loaded.toString(),
            'dependsOn': bind.dependsOn.map((e) => e.toString()).toList(),
          },
        );
      }
    }

    final allReferencesThaIsKeepAlive = references
        .where((element) => element.bindings.any((bind) => bind.keepAlive))
        .toList();
    myMap['permanent'] = <Map<String, dynamic>>[];
    for (var ref in allReferencesThaIsKeepAlive) {
      for (var bind in ref.bindings) {
        myMap['permanent']!.add(
          {
            'className': bind.bindingClassName,
            'type': bind.type.name,
            'keepAlive': bind.keepAlive.toString(),
            'loaded': bind.loaded.toString(),
            'dependsOn': bind.dependsOn.map((e) => e.toString()).toList(),
            'by': ref.id,
          },
        );
      }
    }
 */
    return myMap;
  }
}

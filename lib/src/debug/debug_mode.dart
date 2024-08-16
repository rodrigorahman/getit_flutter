import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../flutter_getit.dart';

export 'debug_web.dart' if (dart.library.io) 'debug_device.dart';

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

    var myMap = <String, List<Map<String, dynamic>>>{};

    for (var ref in references) {
      myMap[ref.id] = <Map<String, dynamic>>[];
      for (var bind in ref.bindings) {
        myMap[ref.id]!.add(
          {
            'className': bind.bindingClassName,
            'type': bind.type.name + (bind.keepAlive ? ' (keepAlive)' : ''),
          },
        );
      }
    }

    return myMap;
  }

  static fGetItLog(String data) {
    if (isEnable && !kReleaseMode) {
      // if (getPlatform() == 'iOS' || getPlatform() == 'Web') {
      log(data, name: 'FGetIt');
      /* if (Platform.isIOS) {
        log(data, name: 'FGetIt');

      } else {
        debugPrint(data);
      } */
      // }
    }
  }
}

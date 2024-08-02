import 'package:flutter_getit/flutter_getit.dart';

class MyDebugLog extends FGetItLoggerConfig {
  MyDebugLog()
      : super(
          colored: false,
          enable: false,
          gettingInstance: false,
          gettingAsyncInstance: false,
          allReady: false,
          disposeInstance: false,
          registerInstance: false,
          disposingInstance: false,
          enterAndExitModule: false,
          enterAndExitWidget: false,
        );
}

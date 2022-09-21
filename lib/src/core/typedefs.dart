import 'package:flutter/cupertino.dart';

import '../../flutter_getit.dart';

typedef ApplicationBindingsBuilder = List<Bind> Function();

typedef BindBuilder = Bind Function();

typedef BindRegister<T> = T Function(Injector i);

typedef ApplicationBuilder = Widget Function(
    BuildContext context, Widget? child);

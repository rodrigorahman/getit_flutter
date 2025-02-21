import 'package:flutter_getit/flutter_getit.dart';

class ProductDetailController with FlutterGetItMixin {
  late final int productId;

  @override
  void onDispose() {}

  @override
  void onInit() {
    // productId = FlutterGetIt.arguments;
  }
}

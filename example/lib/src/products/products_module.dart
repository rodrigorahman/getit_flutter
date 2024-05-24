import 'package:example/src/products/product_controller.dart';
import 'package:example/src/products/products_detail.dart';
import 'package:example/src/products/products_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ProductsModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Products';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => ProductController(),
        )
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/Page': (context) => ProductsPage(
              ctrl: context.get(),
            ),
        '/Detail': (context) => const ProductsDetail(),
      };
}

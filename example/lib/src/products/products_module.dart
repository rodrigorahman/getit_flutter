import 'package:example/src/products/product_controller.dart';
import 'package:example/src/products/products_detail.dart';
import 'package:example/src/products/products_page.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ProductsModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Products';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Page',
          page: (context, isReady, loader) => ProductsPage(
            ctrl: context.get(),
          ),
          bindings: [
            Bind.lazySingleton(
              (i) => ProductController(),
            )
          ],
          pages: [
            FlutterGetItPageRouter(
              name: '/Detail',
              page: (context, isReady, loader) => const ProductsDetail(),
              bindings: [],
            ),
          ],
        ),
      ];

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

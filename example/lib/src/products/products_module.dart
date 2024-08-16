import 'package:example/src/loader/load_dependencies.dart';
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
        FlutterGetItModuleRouter(
          name: "/Page",
          pages: [
            FlutterGetItPageRouter(
              name: '/',
              builderAsync: (context, isReady, loader) => switch (isReady) {
                true => ProductsPage(
                    ctrl: context.get(),
                  ),
                false => loader ?? const WidgetLoadDependencies(),
              },
              bindings: [
                Bind.lazySingleton(
                  (i) => ProductController(),
                )
              ],
            ),
            FlutterGetItPageRouter(
              name: '/Detail',
              builderAsync: (context, isReady, loader) => switch (isReady) {
                true => const ProductsDetail(),
                false => loader ?? const WidgetLoadDependencies(),
              },
              bindings: [],
            ),
          ],
        ),
        // FlutterGetItPageRouter(
        //   name: '/Page',
        //   builderAsync: (context, isReady, loader) => switch (isReady) {
        //     true => ProductsPage(
        //         ctrl: context.get(),
        //       ),
        //     false => loader ?? const WidgetLoadDependencies(),
        //   },
        //   bindings: [
        //     Bind.lazySingleton(
        //       (i) => ProductController(),
        //     )
        //   ],
        //   pages: [
        //     FlutterGetItPageRouter(
        //       name: '/Detail',
        //       builderAsync: (context, isReady, loader) => switch (isReady) {
        //         true => const ProductsDetail(),
        //         false => loader ?? const WidgetLoadDependencies(),
        //       },
        //       bindings: [],
        //     ),
        //   ],
        // ),
      ];

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

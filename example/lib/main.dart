import 'package:example/src/application/binds/my_applications_binds.dart';
import 'package:example/src/home/home_controller.dart';
import 'package:example/src/home/home_page.dart';
import 'package:example/src/middlewares/my_async_middleware.dart';
import 'package:example/src/products/detail/product_detail_controller.dart';
import 'package:example/src/products/detail/product_detail_page.dart';
import 'package:example/src/products/middlewares/product_middleware.dart';
import 'package:example/src/products/products_controller.dart';
import 'package:example/src/products/products_home.dart';
import 'package:example/src/products/service/product_service.dart';
import 'package:example/src/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MainApp());
}

final routeParse = MyRouteInformationParser();

final router = FGetItRouterDelegate(
  applicationBindings: myApplicationBinds,
  middlewares: [
    myAsyncMiddleware,
  ],
  loaderBuilder: (stream) => StreamBuilder<Type>(
    stream: stream,
    builder: (context, snapshot) {
      return Scaffold(
        backgroundColor: snapshot.data is FlutterGetItInitializationMiddleware
            ? Colors.white
            : Colors.black54,
        body: switch (snapshot.data) {
          MyAsyncMiddleware() => const Center(
              child: Text('MyAsyncMiddleware...'),
            ),
          _ => const Center(
              child: FlutterLogo(),
            ),
        },
      );
    },
  ),
  routes: [
    FlutterGetItRoute(
      path: '/',
      buildPage: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        FGetItRouterParams params,
      ) =>
          const SplashPage(),
      binds: [],
    ),
    FlutterGetItRoute(
      path: '/Home',
      buildPage: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        FGetItRouterParams params,
      ) =>
          const HomePage(
        title: '1',
      ),
      binds: [
        Bind.lazySingleton(
          (context) => HomeController(),
        ),
      ],
    ),
    FlutterGetItModuleRoute(
      path: '/Products',
      redirect: '/Products/',
      binds: [
        Bind.lazySingleton(
          (context) => ProductService(),
        ),
      ],
      middlewares: [
        ProductMiddleware(),
      ],
      pages: [
        FlutterGetItRoute(
          path: '/',
          buildPage: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            FGetItRouterParams params,
          ) =>
              const ProductsHome(),
          binds: [
            Bind.lazySingleton(
              (context) => ProductsController(),
            ),
          ],
        ),
        FlutterGetItRoute(
          path: '/:productId/Detail',
          buildPage: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            FGetItRouterParams params,
          ) =>
              const ProductDetailPage(),
          binds: [
            Bind.lazySingleton(
              (context) => ProductDetailController(),
            ),
          ],
        ),
      ],
    ),
  ],
);

final myAsyncMiddleware = MyAsyncMiddleware();
final myApplicationBinds = MyApplicationsBinds();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: router,
      debugShowCheckedModeBanner: false,
      routeInformationParser: routeParse,
    );
  }
}

class MyRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    print(routeInformation);
    return routeInformation.uri.path;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}

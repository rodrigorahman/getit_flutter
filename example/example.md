
## User Injection

```dart
class HomePage extends StatelessWidget {
  
  final controller = Injector.get<HomeController>();
  
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = context.get<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(child: Text(controller.name)),
    );
  }
}
```

## Route

```dart
class HomeRoute extends FlutterGetItPageRouter {
  
  const HomeRoute({super.key});
  
  @override
  List<Bind> get bindings => [
    Bind.singleton((i) => HomeController())
  ];  
  
  @override
  WidgetBuilder get view => (context) => HomePage();
}
```

## Configuration

```dart
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      // "Add here the pages that will be loaded."
      pages: [
        FlutterGetItPageBuilder(
          page: (context) => const MyHomePage(title: 'home'),
          path: '/',
        ),
      ],
      // In this method, the MaterialApp or Cupertino App should be returned.
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          // Add the flutterGetItNavObserver attribute here.
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // Add the routes attribute here.
          routes: routes,
        );
      },
    );
  }
}
````

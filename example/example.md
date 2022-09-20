# Exemplos

## Exemplo de page

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

## Exemplo de rota

```dart
class HomeRoute extends GetItPageRoute {
  
  const HomeRoute({super.key});
  
  @override
  List<Bind> get bindings => [
    Bind.singleton((i) => HomeController())
  ];  
  
  @override
  WidgetBuilder get view => (context) => HomePage();
}
```

## Exemplo de configuração

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeRouter(),
    );
  }
}
````

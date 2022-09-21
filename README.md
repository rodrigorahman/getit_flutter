# Flutter GetIt

Projeto que permite você utilizar o GetIt como um dependency injection porém controlado pelo ciclo de vida do Flutter, fazendo o register e o unregister na navegação da página.

## Existem 3 tipos possíveis de Widgets

- **FlutterGetItPageRoute**
- **FlutterGetItWidget**
- **FlutterGetItPageBuilder**

## Entenda a diferença de cada um deles

### FlutterGetItPageRoute

Utilizado para controlar por navegação, sendo utilizado especificamente em rotas no Flutter ex

```dart
class ProductsRoute extends FlutterGetItPageRoute {
  const ProductsRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.singleton((i) => ProductsController()),
      ];

  @override
  WidgetBuilder get page => (context) => ProductsPage();
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
      routes: {
        '/products': (context) => const ProductsRoute()
      },
    );
  }
}
```

## Getter page

Método page você deve retornar uma função com a sua página. No atributo você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.

## Getter bindings

Esse método será a base para a injeção das dependencias, você deve registrar as classes que serão utilizadas na view e o getit_flutter fará o restante.

### FlutterGetItWidget

Essa classe deve ser utilizada quando você quer ter esse mesmo suporte porém para Componentes (Widgets)

```dart
class CounterWidget extends FlutterGetitWidget {
  @override
  List<Bind<Object>> get bindings =>
      [Bind.lazySingleton((i) => CounterController())];

  const CounterWidget({super.key});

  @override
  WidgetBuilder get widget => (context) => _CounterWidget(
        controller: context.get(),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CounterWidget(),
        ],
      ),
    );
  }
}
```

## Getter widget

Método widget você deve retornar uma função com a seu widget(componente), no atributo você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.

## Getter bindings (Identico ao Getter bindings do FlutterGetItPageRoute)

Esse método será a base para a injeção das dependencias, você deve registrar as classes que serão utilizadas na view e o getit_flutter fará o restante.


### FlutterGetItPageBuilder

Esse Widget é um atalho para quando você tem um único binding e não que crir uma classe de Rota;

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => FlutterGetItPageBuilder(
              binding: () => Bind.singleton((i) => HomeController()),
              page: (context) => const HomePage(),
            ),
      },
    );
  }
}
```

## Atributo page

Atributo page você deve retornar uma função com a sua página e no atributo você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.

## Atributo binding

Esse atributo você deve retornar o binding que você quer adicionar na página e o getit_flutter fará o restante.

## Binds

Você tem três possibilidades de utilização em todas você deve passar uma função anônima que recebera como parâmetro a classe Injector que te da a possibilidade de buscar uma instancia dentro do motor de injeção no caso o GetIt

### Tipos de registros

- **Bind.singleton**
- **Bind.lazySingleton**
- **Bind.factory**

### Exemplo Completo

```dart
class LoginRoute extends GetItPageRoute {
  
  const LoginRoute({super.key});
  
  @override
  List<Bind> get bindings => [
    Bind.singleton((i) => HomeRepository())
    Bind.lazySingleton((i) => HomeRepository())
    Bind.factory((i) => HomeController())
  ];  
  
  @override
  WidgetBuilder get view => (context) => LoginPage();
}
```

## Diferentes formas de registros

### Factory (Bind.factory)

```dart
    Bind.factory((i) => HomeController())
```

A factory faz com que toda vez que você pedir uma instancia para o gerenciador de dependencias ele te dara uma nova instancia.

#### Singleton (Bind.singleton)

```dart
    Bind.singleton((i) => HomeController())
```

O singleton faz com que toda vez que for solicitado uma nova instancia para o gerenciador de dependencias ele te dará a mesma instancia.

>**Obs:** O Bind.singleton tem a caracteristica de iniciar a classe logo no carregamento da página.

### Lazy Singleton (Bind.lazySingleton)

```dart
    Bind.lazySingleton((i) => HomeController())
```

O Lazy Singleton faz com que toda vez que for solicitado uma nova instancia para o gerenciador de dependencias ele te dará a mesma instancia, porém diferente do singleton esse Bind não inicia a instancia logo no load da página, será criado somente quando for solicitado pela primeira vez.

## Recuperando instancia

Para recuperar a instancia da classe você tem 2 opções utilizando a classe Injector e a extension que adiciona o Injector dentro do BuildContext

### Ex

```dart
Injector.get<HomeController>();

// ou

context.get<HomeController>();
```

### Exemplo utilizando extension no BuildContext

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

### Exemplo utilizando Injector

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

## OBS.: Se você olhar o código fonte dos tipos de widget verá que eles são praticamente identicos, porém eles foram criado pensando em um propósito`(Semântica)`, a semântica de um projeto é muito importante para ajudar na manutenção. Sendo assim para você não ter que usar uma classe FlutterGetItRoute em um widget(Componente que não seja uma Page) e deixar o seu projeto totalmente sem sentido, criamos os Widgets certos para cada objetivo 'Page' ou 'Widget'

## Projeto com exemplo dos três tipos

[Projeto exemplo](https://github.com/rodrigorahman/example_flutter_getit)

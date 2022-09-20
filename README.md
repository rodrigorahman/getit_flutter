# Flutter GetIt

Projeto complementar onde permite você utilizar o GetIt como um dependency injection porém controlado pela navegação da tela, fazendo o register e o unregister na navegação da página.

## Todo a implementação está baseado na extensão da classe GetItPageRoute, onde essa classe será a base para sua view

## Exemplo

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

## Getter view

Método view você deve retornar uma função com a sua página. No atributo você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.

## Getter bindings

Esse método será a base para a injeção das dependencias, você deve registrar as classes que serão utilizadas na view e o getit_flutter fará o restante.

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

#### Factory (Bind.factory)

```dart
    Bind.factory((i) => HomeController())
```

A factory faz com que toda vez que você pedir uma instancia para o gerenciado de dependencias ele te dara uma nova instancia.

#### Singleton (Bind.singleton)

```dart
    Bind.singleton((i) => HomeController())
```

O singleton faz com que toda vez que for solicitado uma nova instancia para o gerenciador de dependencias ele te dará a mesma instancia.

>**Obs:** O Bind.singleton tem a caracteristica de iniciar a classe logo no carregamento da página.

#### Lazy Singleton (Bind.lazySingleton)

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

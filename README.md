# Flutter GetIt

Projeto que permite você utilizar o get_it como um dependency injection porém controlado pelo ciclo de vida do Flutter, fazendo o register e o unregister na navegação da página.


# Existem 5 tipos classes para controle das dependências

- **FlutterGetItApplicationBinding**
- **FlutterGetItPageRoute**
- **FlutterGetItWidget**
- **FlutterGetItPageBuilder**
- **FlutterGetItModuleRoute**


# Configurando flutter_getit 

A configuração das rotas são feitas baseadas na classes [FlutterGetItPageRoute], [FlutterGetItModuleRoute] ou por rotas nativas do flutter. 

O flutter_getit não fará nenhuma mágica com as rotas ele apenas vai automatizar a criação das rotas nomeadas do Flutter puro. Isso é importante pois você pode usar todo o poder de navegação do flutter sem a necessidade de nenhuma adaptação ou conhecimento extra do package.

A classe responsável pela configuração é a [FlutterGetIt] dentro dela existe o método estático ***routes*** com os paramêtros [ modules, pages e custom], abaixo um detalhe de cada um deles: 

| Campo       | Descrição
|-------------|-------------
| modules     | Esse atributo recebe uma lista de módulos [FlutterGetItModuleRoute] esse atribuito traz a possibilidade de modularizar todo o seu sistema, mais a baixo teremos um tópico especifico sobre ele
| pages       | Caso você não tenha a necessidade modularizar o seu sistema ou quer apenas implementar uma rota simples diretamente para uma pagina você deve adicionar nessa lista, ela vai receber classes filhas de FlutterGetItPageRoute
| custom      | Aqui você pode customizar as rotas da mesma forma que você já fazia com o flutter puro, enviando um map com a rota e uma função que recebe context.


> **Obs:** Todos os campos são opcionais, podendo ser utilizados em conjunto ou separadamente

## Veja um exemplo de configuração com todos os parametros.

```dart
class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.get<UserModel>().email,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: FlutterGetIt.routes(
        pages: [
          const ProductsRoute(),
        ],
        modules: [
          AuthModule(),
        ],
        custom: {
          '/': (context) => FlutterGetItPageBuilder(
                binding: () => Bind.singleton((i) => HomeController()),
                page: (context) => const HomePage(),
              ),
          '/counter': (context) => Scaffold(body: CounterWidget())
        },
      ),
    );
  }
}
```



## FlutterGetItApplicationBinding

Application binding são os bindings que **NUNCA** serão removido de dentro do get_it utilize essa class para declarar as dependências que ficarão ativas por todo o sistema. 

Normalmente utilizado para classes que são core do sistema.

> *****ATENÇÃO:*** AS CLASSES DECLARADAS AQUI NUNCA SERÃO REMOVIDAS DA MEMÓRIA SENDO ASSIM TOME CUIDADO. AQUI NÃO É O LUGAR DE COLOCAR MUITAS CLASSES E SIM SOMENTE O QUE FOR UTILIZADO POR MAIS DE UMA PAGINA OU VOCÊ QUEIRA DEIXAR GLOBAL PARA O SISTEMA.**

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterGetItApplicationBinding(
      bindingsBuilder: () => [
        Bind.lazySingleton((i) => UserModel(
            name: 'Rodrigo Rahman',
            email: 'rodrigorahman@academiadoflutter.com.br'))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      
        routes: FlutterGetIt.routes(
          pages: [
            const ProductsRoute(),
          ],
        ),
      ),
    );
  }
}
```

## Configurando FlutterGetItApplicationBinding

Descrição dos atributos FlutterGetItApplicationBinding:

| Campo       | Descrição
|-------------|-------------
| child       | Nesse atributo você deve informar o widget que será iniciado normalmente será adicionado o MaterialApp 2      
| builder     | Esse atributo pode ser utilizado para quando você já quer disponível o BuildContext ou mesmo para buscar alguma classe que foi injetada nos bindings do FlutterGetItApplicationBinding.
| bindings    | Nesse atribuito você deve enviar uma classe filha de ApplicationBindings, a classe ApplicationBindings é onde você define as dependências que o flutter_getit deve disponibilizar para a aplicação como um todo.
| bindingsBuilder | Esse atributo permite você informar cada uma das suas dependências em formato de array. **OBS:** aconselhamos a utilização dele somente se você tiver poucas classes, em caso de uma quantidade grande de classes aconselhamos a utilização do bindings deixando assim seu código muito mais organizado.


### **Exemplo utilizando ***[bindingsBuilder]*****
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterGetItApplicationBinding(
      bindingsBuilder: () => [
        Bind.lazySingleton((i) => UserModel(
          name: 'Rodrigo Rahman',
          email: 'rodrigorahman@academiadoflutter.com.br'),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        )
      ),
      routes: FlutterGetIt.routes(
        pages: [
          const ProductsRoute(),
        ],
      ),
    );
  }
}
```

### **Exemplo utilizando *[bindings]* e *[builder]*** 
```dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterGetItApplicationBinding(
      bindings: ExampleApplicationBindings(),
      builder: (context, child) {
        debugPrint(
          context.get<UserModel>().email,
        );
        return child
      },
      child: MaterialApp(
          title: context.get<UserModel>().email,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: FlutterGetIt.routes(
            pages: [
              const ProductsRoute(),
            ],
          ),
        );
    );
  }
}

```

## FlutterGetItPageRoute

A class [FlutterGetItPageRoute] é responsável pelas páginas Flutter é nela que configuramos as dependências e a página que será carregada pelo Flutter.

| Metodo      | Descrição
|-------------|-------------
| bindings    | Nesse getter você declara as dependências que a página irá utilizar
| page        | Nesse getter você deve retornar uma função com sua página, no atributo você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.
| routeName   | Nesse getter você deve informar a rota que será configurada dentro do flutter


```dart
class ProductsRoute extends FlutterGetItPageRoute {
  const ProductsRoute({super.key});

  @override
  String get routeName => '/products';

  @override
  List<Bind<Object>> get bindings => [
        Bind.singleton((i) => ProductsController()),
      ];

  @override
  WidgetBuilder get page => (context) => ProductsPage();
  
}
```

### FlutterGetItWidget

Classe que da suporte a controle de depêndencias(bindings) para widgets simples que podem ser usados em partes do sistema e não tenha a necessidade de estar associado diretamente a uma rota.

| Metodo      | Descrição
|-------------|-------------
| bindings    | Esse método será a base para a injeção das dependencias, você deve registrar as classes que serão utilizadas na view e o getit_flutter fará o restante.
| widget      | Método widget você deve retornar uma função com a seu widget(componente), no atributo você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.


```dart
class CounterWidget extends FlutterGetItWidget {
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

### FlutterGetItPageBuilder

Classe facilitadora, utilizada quando você necessita de uma única classe de dependência(binding) e não quer criar uma classe apartada para essa rota.

>**OBS.:** na configuração essa classe deve ser adicionada na tag de configuração custom conforme o exemplo abaixo:

| Metodo      | Descrição
|-------------|-------------
| binding     | Esse atributo você deve retornar o binding que você quer adicionar na página e o getit_flutter fará o restante.
| page        | Esse atributo você deve retornar uma função com a sua página, no atributo dessa função você receberá uma variável context que é o BuildContext da página e com ele você pode recuperar instancias ou fazer o que for necessário.



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
      custom: {
        '/': (context) => FlutterGetItPageBuilder(
              binding: () => Bind.singleton((i) => HomeController()),
              page: (context) => const HomePage(),
            ),
      },
    );
  }
}
```

### FlutterGetItModuleRoute

Essa classe da o suporte ao projeto utilizar uma arquitetura de módulos, com ela você pode compartilhar bindings ou mesmo utilizar qualquer outra classe de rota internamente.

| Metodo      | Descrição
|-------------|-------------
| moduleRouteName | Esse getter você deve informar qual a rota base para seu módulo, esse valor será concatenado com as rotas das páginas (Lembre sempre de começar com /).
| bindings     | Esse getter você deve retornar o binding que você quer adicionar na página e o getit_flutter fará o restante.
| pages        | esse getter você deve retornar um mapa com as rotas desse módulo, no valor do mapa você deve retornar uma função que no atributo receberá o context(BuildContext), o retorno deve ser um widget e pode ser uma página simples ou qualquer classe do FlutterGetIt([FlutterGetItModuleRoute] [FlutterGetItPageRoute], [FlutterGetItPageBuilder] ou [FlutterGetItWidget])

```dart

class AuthModule extends FlutterGetItModuleRoute {
  @override
  String get moduleRouteName => '/auth';

  @override
  List<Bind> get bindings => [
        Bind.singleton<AuthService>(
            (i) => AuthService(name: 'Rodrigo', email: 'auth@academiadoflutter.com.br'))
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/login': (context) => const AuthLogin(),
        '/register': (context) => const AuthRegister()
      };
}

class AuthLogin extends StatelessWidget {
  const AuthLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.get<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          Text(user.name),
          Text(user.email),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/Auth/page2'),
            child: const Text('Modulo page2'),
          )
        ],
      ),
    );
  }
}

class AuthRegister extends StatelessWidget {
  const AuthRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.get<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [Text(user.name), Text(user.email)],
      ),
    );
  }
}

```

> Para configuração você deve passar essa classe no atributo modules do [FlutterGetIt.route]:´

```dart
class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.get<UserModel>().email,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: FlutterGetIt.routes(
        modules: [
          AuthModule(),
        ],
      ),
    );
  }
}
```

Existe uma grande vantagem da utilização do [FlutterGetItModuleRoute] em conjunto com [FlutterGetItPageRoute] pois você não tem a necessidade de declarar classes especificas da pagina dentro do módulo

Normalmente quando utilizamos a arquitetura de módulos é muito comum termos a declaração das controllers das páginas declaradas dentro do módulo, como o exemplo abaixo: 

```dart
class AuthModule extends FlutterGetItModuleRoute {
  @override
  String get moduleRouteName => '/auth';

  @override
  List<Bind> get bindings => [
        Bind.factory<AuthLoginController>(
            (i) => AuthLoginController()),
        Bind.factory<AuthRegisterController>(
            (i) => AuthLoginController())
      ];

  @override
  Map<String, WidgetBuilder> get pages => {
        '/login': (context) => const AuthLogin(),
        '/register': (context) => const AuthRegister()
      };
}
```

Dessa forma temos a necessidade de declarar nosso controllers como sendo factory deixando a construção um pouco mais complexa e mantendo a controller mesmo que você saia da tela 

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

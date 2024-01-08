# Flutter GetIt

Este pacote é uma ferramenta essencial para o gerenciamento eficiente de dependências no ciclo de vida do seu projeto Flutter. Ele oferece suporte robusto para o controle de páginas, incluindo a gestão de rotas e a flexibilidade de trabalhar com módulos.

## **Recursos Principais:**

**Controle Dinâmico de Dependências:** Utilizando o poderoso mecanismo do get_it, este pacote registra e remove automaticamente as dependências conforme necessário, otimizando o desempenho e garantindo a eficiência do seu aplicativo.

**Módulos Flexíveis:** Aproveite a modularidade do seu código. Este pacote facilita a criação e gerenciamento de módulos, tornando seu projeto mais organizado e fácil de manter.

Benefícios Adicionais:

**Limpeza Automática de Dependências:** O pacote se encarrega de retirar as dependências quando não são mais necessárias, garantindo uma gestão eficiente dos recursos do seu aplicativo.


>O Flutter GetIt oferece diversas abordagens para controlar as rotas e carregar os bindings da sua aplicação, incluindo rotas de páginas, builders e módulos você verá detalhes de cada uma delas mais pra frente 


# Inicio

## Configurando flutter_getit 

A configuração do Flutter GetIt é realizada adicionando um widget ao redor do seu MaterialApp. Ao incluir o widget e implementar o atributo builder, três atributos serão enviados para você:

| Campo                   | Descrição
|-------------------------|-------------
| context                 | BuildContext
| routes                  | Um mapa que deve ser adicionando na tag routes do MaterialApp ou CupertinoApp
| flutterGetItNavObserver | Esse atributo é um NavigatorObserver esse atributo deve ser adicionado no atributo **navigatorObservers** do MaterialApp.
|


Os atributos **[routes]** e **[flutterGetItNavObserver]** devem ser repassados para o MaterialApp, conforme ilustrado no exemplo abaixo:

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
      // Adiciona aqui as páginas que serão carregadas
      pages: [
        FlutterGetItPageBuilder(
          page: (context) => const MyHomePage(title: 'home'),
          path: '/',
        ),
      ],
      // Nesse método deve ser retornado o MaterialApp ou Curpertino App
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          // Adicione aqui o atributo flutterGetItNavObserver
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // Adicione o atributo das rotas aqui
          routes: routes,
        );
      },
    );
  }
}
```

O Flutter GetIt não reescreve as rotas padrão do Flutter; ele cria uma estrutura utilizando o ciclo de vida nativo do Flutter. Essa abordagem evita a reescrita desnecessária da navegação da aplicação, prevenindo bugs e problemas indesejados

Poréma para ele ter o controle das dependências você deve registrar as páginas da sua aplicação nos atributos [pages] conforme o exemplo acima ou [modules] que você verá um pouco mais pra frente.

## FlutterGetItPageBuilder

No exemplo acima, você viu a forma mais simples de implementar uma rota dentro do flutter_getit. Se a sua página for tão simples quanto a nossa página inicial, você pode utilizar a classe de builder, adicionando a página e o caminho ao qual ela irá responder.

```dart
FlutterGetItPageBuilder(
  // Define a página que será exibida quando a rota for acessada
  page: (context) => const MyHomePage(title: 'home'),
  // Define o caminho da rota
  path: '/',
),
```

Agora, se você precisa controlar alguma dependência logo no carregamento da sua home_page, você pode utilizar o atributo binding. Ao adicionar este atributo, é possível especificar a dependência que será utilizada na sua página

```dart
FlutterGetItPageBuilder(
  // Adiciona o binding para controlar dependências durante o carregamento da página
  binding: () => Bind.lazySingleton((i) => PageXController()),
  // Define a página que será exibida quando a rota for acessada
  page: (context) => const PageX(),
  // Define o caminho da rota
  path: '/pagex',
),

```

Dessa forma, o flutter_getit adicionará, durante o carregamento da sua tela, uma instância de PageXController ao get_it, possibilitando a utilização da sua página. No entanto, é importante destacar que ao sair dessa tela, o flutter_getit eliminará a instância da memória do seu aplicativo, garantindo uma gestão eficiente dos recursos.

## Dependências de aplicação

Todo projeto necessita de dependencias que devem ficar ativas pela aplicação toda, ex: RestClient(Dio), Log e muitas outras. Para o flutter_getit também disponibiliza isso pra você basta na inicialização [FlutterGetIt] você enviar o parâmetro [bindingsBuilder] ou [bindings].

## Exemplo utilizando **[bindingsBuilder]**

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
      bindingsBuilder: () {
        return [
          Bind.lazySingleton((i) => ServiceForApplication()),
        ];
      },
      pages: [
        FlutterGetItPageBuilder(
          page: (context) => const MyHomePage(title: 'home'),
          path: '/',
        ),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: routes,
        );
      },
    );
  }
}
```

## Atributo [bindings]

Em projeto grandes a lista de dependencias de aplicação pode ser um pouco maior e para deixar o projeto um pouco mais organizado aconselho você a utilizar o atributo bindings. Nele você vai poder passar uma classe para o carregamento das suas dependências.

```dart
// Crie uma classe extendendo [ApplicationBindings]
class ExemploApplicationBinding extends ApplicationBindings {

  // retorne em um array todas as dependências de aplicação
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton((i) => ServiceForApplication()),
      ];
}

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
      // Adicione aqui a classe de binding
      bindings: ExemploApplicationBinding(),
      pages: [
        FlutterGetItPageBuilder(
          page: (context) => const MyHomePage(title: 'home'),
          path: '/',
        ),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: routes,
        );
      },
    );
  }
}
```

## Recuperando instancia

Existem 2 formas de recuperar uma instancia do flutter_getit, são elas por meio da classe [Injector] ou por meio de uma extension adicionado no BuildContext [context.get]

```dart
Injector.get<ServiceForApplication>();

// ou

context.get<ServiceForApplication>();
```

### Exemplo utilizando direto no BuildContext


```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var service = context.get<ServiceForApplication>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(child: Text(service.name)),
    );
  }
}
```


### Exemplo utilizando Injector 

```dart
class HomePage extends StatelessWidget {
  
  final service = Injector.get<ServiceForApplication>();
  
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(child: Text(service.name)),
    );
  }
}
```

## Não para por ai

Apenas com esses passos, você já pode utilizar o Flutter GetIt, mas há muito mais recursos disponíveis. 

Manter seu projeto organizado é sempre a melhor abordagem, proporcionando maior facilidade durante a manutenção e pensando nisso, adicionamos suporte a rotas e módulos no pacote, proporcionando uma experiência ainda mais robusta e estruturada.

# Rotas

Com a classe [FlutterGetItPageBuilder] você já está trabalhando com as rotas gerênciadas porém você pode deixar seu projeto mais organizado utilizando a classe **[FlutterGetItPageRouter]**

## FlutterGetItPageRouter

Essa classe é responsável pela rota da sua aplicação veja um exemplo: 

| Método | Descrição
|--------|-----------
| bindings | Método onde você vai declarar cada uma das suas dependências
| routeName | Aqui você declara o path da sua rota
| view | É o método que retorna o widget que representa seu Stateless ou Stateful Widget (página).



```dart
class LoginRoute extends FlutterGetItPageRouter {
  const LoginRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton((i) => LoginController(serviceForApplication: i()))
  ];

  @override
  String get routeName => '/login';

  @override
  WidgetBuilder get view => (context) => const LoginPage();
}



class LoginPage extends StatelessWidget {

  const LoginPage({ super.key });

   @override
   Widget build(BuildContext context) {
    final controller = context.get<LoginController>();
       return Scaffold(
           appBar: AppBar(title: const Text('Login Page'),),
           body: Column(
             children: [
               Text(controller.getUserName()),
               Text(controller.getNameService()),
             ],
           ),
       );
  }
}
```

No exemplo acima nós deixamos de criar uma rota simples pelo builder e criamos uma classe que representa a nossa rota nela você define as dependências dessa rota [bindings] o nome da rota [routeName] que será acessada pelo Navigator do flutter e a [view] que é o método que retorna o widget que representa seu Stateless ou Stateful Widget.

# Configurando sua rota

```dart
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_getit_2_example/routes/login/login_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      pages: [
        // Adicione aqui a instancia da sua rota.
        LoginRoute(),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: routes,
        );
      },
    );
  }
}
```

# Módulos

A partir  da versão 2.0 o flutter_getit te da também o suporte a módulos

Para utilizar o conceito de módulos do flutter_getit você primeiro criar a sua classe que vai representar o seu módulo extendendo a classe [FlutterGetItModule]

| Metodo      | Descrição
|-------------|-------------
| moduleRouteName | Esse getter você deve informar qual a rota base para seu módulo, esse valor será concatenado com as rotas das páginas (Lembre sempre de começar com /).
| bindings     | Esse getter você deve retornar o binding que você quer adicionar na página e o getit_flutter fará o restante.
| pages        | Esse getter você deve retornar um mapa com as rotas desse módulo, no valor do mapa você deve retornar uma função que no atributo receberá o context(BuildContext), o retorno deve ser um widget e pode ser uma página simples ou [FlutterGetItModulePageRouter])

```dart
class AuthModule extends FlutterGetItModule {

  // Bindings do módulo como um todo
  @override
  List<Bind> get bindings => [
    Bind.lazySingleton((i) => LoginRepository())
  ];

  // Caminho base do seu módulo
  @override
  String get moduleRouteName => '/auth';


  // Páginas do seu módulo
  @override
  Map<String, WidgetBuilder> get pages => {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage()
      };
}
```

Vamos começar pelos bindings, esse getter ele funciona exatamente como os outros a diferença está no ciclo de vida, um binding dentro de um módulo só será eliminado quando o usuário sair do módulo como um todo ex: 

Usuário entrou na tela **/auth/login** isso quer dizer que ele entrou no módulo **/auth** na página **/login** se o usuário clicar em um link que vá para a tela de **/auth/register** o flutter_getit entendeu que o usuário está indo para o mesmo módulo e não vai eliminar as dependencias do modulo **/auth**. Ele só vai elimitar as dependencias do modulo **/auth** quando o usuário sair do módulo e for para outro como por exemplo um **/products/**.

## Configurando um módulo

Para configurar um módulo basta você adicionar no [FlutterGetIt] o atributo modules:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_getit_2_example/modules/auth/auth_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      modules: [AuthModule()]
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Flutter Demo',
          navigatorObservers: [flutterGetItNavObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: routes,
        );
      },
    );
  }
}
```

E automaticamente o flutter_getit criará as rotas ***/auth/login*** e ***/auth/register***

# Diferencial do modulo em conjunto com [FlutterGetItModulePageRouter]

Trabalhar com módulos pode ocasionalmente demandar a declaração de controllers ou dependências que serão utilizadas exclusivamente em uma das páginas do módulo. Um exemplo disso são as controllers, frequentemente associadas a uma única página. No entanto, alguns pacotes geralmente requerem que você declare a instância da controller dentro do módulo, como exemplificado abaixo:

```dart
class AuthModule extends FlutterGetItModule {

  // Bindings do módulo como um todo
  @override
  List<Bind> get bindings => [
    Bind.lazySingleton((i) => LoginRepository())
    // Controller do login
    Bind.lazySingleton((i) => LoginController())
    // Controller do register
    Bind.lazySingleton((i) => RegisterController())
  ];

  // Caminho base do seu módulo
  @override
  String get moduleRouteName => '/auth';


  // Páginas do seu módulo
  @override
  Map<String, WidgetBuilder> get pages => {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage()
      };
}
```

Diferentemente de outras abordagens, o flutter_getit permite que as controllers do login e do registro permaneçam ativas somente quando necessárias.

## FlutterGetItModulePageRouter

A classe [FlutterGetItModulePageRouter] te ajuda a com isso veja o exemplo: 

Abaixo criamos uma classe LoginPageRoute onde declaramos os bindings e qual a view que será apresentada

```dart
class LoginPageRoute extends FlutterGetItModulePageRouter{
  const LoginPageRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton((i) => LoginController(repository: i()))
  ];

  @override
  WidgetBuilder get view => (context) => const LoginPage();  
}
```

Agora no nosso AuthModule na rota de login, nós não apontamos mais diretamente para a página LoginPage, mas sim para a rota LoginPageRoute.

```dart 
class AuthModule extends FlutterGetItModule {

  @override
  List<Bind> get bindings => [
    Bind.lazySingleton((i) => LoginRepository())
  ];

  @override
  String get moduleRouteName => '/auth';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/login': (context) => const LoginPageRoute(),
        '/register': (context) => const RegisterPage()
      };
}

```

Essa abordagem permite que o mecanismo do flutter_getit reconheça essas dependências como entidades distintas, carregando a LoginController apenas quando a tela correspondente estiver ativa e eliminando-a quando a tela for descarregada. Isso evita a criação de instâncias desnecessárias em sua aplicação, contribuindo para uma gestão mais eficiente de recursos

## Tipos de Binds

Até agora você viu somente um tipo de binding **Bind.lazySingleton** porém o flutter_getit existem todos os outros bindings suportados pelo motor get_it:

Essas possibilidades são 3:

| Bind | Descrição
|------|----------
| Bind.lazySingleton| Esse bind vai inicializar a dependência somente quando o usuário chama-la pela primeira vez, após isso ela se tornara um singleton retornando a mesma instâcia toda vez que requisitada
| Bind.singleton | Diferente da lazySingleton o singleton já fará a inicialização da instancia logo quando a página carregar
| Bind.factory | A factory faz com que toda vez que você pedir uma instancia para o gerenciador de dependencias ele te dara uma nova instancia.

### Exemplo Completo

```dart
class LoginRoute extends FlutterGetItModulePageRouter {
  
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


## Projeto com exemplo

[Projeto exemplo](https://github.com/rodrigorahman/flutter_getit_2_example)

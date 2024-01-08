# Flutter GetIt
<div align="center">


**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/refactory_2_0_0/README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/refactory_2_0_0/README.md)
</div>

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

Porém para ele ter o controle das dependências você deve registrar as páginas da sua aplicação nos atributos [pages] conforme o exemplo acima ou [modules] que você verá um pouco mais pra frente.

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

Todo projeto necessita de dependencias que devem ficar ativas pela aplicação toda, ex: RestClient(Dio), Log e muitas outras. Para o FlutterGetIt, você pode facilmente disponibilizar isso. Basta, durante a inicialização [FlutterGetIt], enviar o parâmetro [bindingsBuilder] ou [bindings].

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
      // Retorne um array com cada um dos bindings que você gostaria de deixar 
      // disponível pela aplicação inteira
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

Em projetos grandes, a lista de dependências de uma aplicação pode ser extensa. Para manter o projeto mais organizado, sugiro o uso do atributo **"bindings"**. Com ele, você pode fornecer uma classe para o carregamento das suas dependências.


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

Existem duas formas de recuperar uma instância do flutter_getit. Uma delas é por meio da classe [Injector], e a outra é por meio de uma extensão adicionada no BuildContext usando [context.get].

```dart
Injector.get<ServiceForApplication>();

// ou

context.get<ServiceForApplication>();
```

### Exemplo utilizando ***[context.get]***


```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Chamando a extension do BuildContext
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

Essa classe é responsável pela definição de rotas da sua aplicação. Veja um exemplo:

| Método | Descrição
|--------|-----------
| bindings | Método onde você vai declarar cada uma das suas dependências
| routeName | Método onde você deve retornar o path da sua rota
| view | Método que retorna o widget que representa seu Stateless ou Stateful Widget (sua página).


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
No exemplo acima, optamos por não criar uma rota simples usando o builder. Em vez disso, criamos uma classe que representa a nossa rota. Nessa classe, você define as dependências dessa rota [bindings], o nome da rota [routeName], que será acessada pelo Navigator do Flutter, e a [view], que é o método que retorna o widget representando seu StatelessWidget ou StatefulWidget.

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

A partir da versão 2.0, o flutter_getit também oferece suporte a módulos.

Para utilizar o conceito de módulos do flutter_getit, você deve primeiro criar a sua classe que representará o seu módulo, estendendo a classe [FlutterGetItModule].


| Metodo      | Descrição
|-------------|-------------
| moduleRouteName | Nesse getter, você deve informar a rota base para o seu módulo. Esse valor será concatenado com as rotas das páginas (Lembre-se sempre de começar com /).
| bindings     | Nesse getter, você deve retornar os bindings que deseja adicionar à página, e o get_it_flutter cuidará do restante.
| pages        | Nesse getter, você deve retornar um mapa com as rotas desse módulo. No valor do mapa, você deve retornar uma função que, como atributo, receberá o contexto (BuildContext). O retorno dessa função deve ser um widget, que pode ser uma página simples ou [FlutterGetItModulePageRouter].

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

Vamos começar pelos bindings. Esse getter funciona exatamente como os outros, a diferença está no ciclo de vida. Um binding dentro de um módulo só será eliminado quando o usuário sair do módulo como um todo. Por exemplo:

Se o usuário entrar na tela ***/auth/login***, significa que ele entrou no módulo ***/auth*** na página ***/login***. Se o usuário clicar em um link que vá para a tela ***/auth/register***, o flutter_getit entenderá que o usuário está indo para o mesmo módulo e não eliminará as dependências do módulo ***/auth***. Ele só eliminará as dependências do módulo ***/auth*** quando o usuário sair do módulo e for para outro, como por exemplo, ***/products/***.

## Configurando um módulo

Para configurar um módulo, basta adicionar no [FlutterGetIt] o atributo modules:


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

E automaticamente, o flutter_getit criará as rotas ***/auth/login*** e ***/auth/register***

## Diferencial do modulo em conjunto com [FlutterGetItModulePageRouter]

Trabalhar com módulos pode ocasionalmente exigir a declaração de controllers ou dependências específicas que serão usadas exclusivamente em uma das páginas do módulo. Um exemplo disso são as controllers, muitas vezes associadas a uma única página. No entanto, alguns pacotes geralmente exigem que você declare a instância da controller dentro do módulo, como exemplificado abaixo:

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

A classe [FlutterGetItModulePageRouter] te ajuda com isso. Veja o exemplo:

Abaixo, criamos uma classe LoginPageRoute onde declaramos os bindings e qual a view que será apresentada.

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

Agora, no nosso AuthModule, na rota de login, não apontamos mais diretamente para a página LoginPage, mas sim para a rota [LoginPageRoute].

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

Até agora, você viu apenas um tipo de binding, **Bind.lazySingleton**. No entanto, o flutter_getit suporta todos os outros bindings suportados pelo motor get_it:

Essas possibilidades são três:

| Bind | Descrição
|------|----------
| Bind.lazySingleton| Esse bind vai inicializar a dependência somente quando o usuário chamá-la pela primeira vez. Após isso, ela se tornará um singleton, retornando a mesma instância toda vez que for requisitada.
| Bind.singleton | Ao contrário do lazySingleton, o singleton fará a inicialização da instância imediatamente quando a página carregar.
| Bind.factory | A factory faz com que toda vez que você solicitar uma instância para o gerenciador de dependências, ele fornecerá uma nova instância.

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

### Lazy Singleton (Bind.lazySingleton)

```dart
    Bind.lazySingleton((i) => HomeController())
```

O Lazy Singleton faz com que, toda vez que for solicitada uma nova instância ao gerenciador de dependências, ele fornecerá a mesma instância. No entanto, ao contrário do singleton, esse Bind não inicializa a instância imediatamente no carregamento da página; ela será criada somente quando solicitada pela primeira vez.

#### Singleton (Bind.singleton)

```dart
    Bind.singleton((i) => HomeController())
```

O singleton faz com que toda vez que for solicitada uma nova instância ao gerenciador de dependências, ele fornecerá a mesma instância.

>**Obs:** O Bind.singleton tem a característica de iniciar a classe logo no carregamento da página.


### Factory (Bind.factory)

```dart
    Bind.factory((i) => HomeController())
```

A factory faz com que toda vez que você solicitar uma instância ao gerenciador de dependências, ele fornecerá uma nova instância.



## Projeto com exemplo

[Projeto exemplo](https://github.com/rodrigorahman/flutter_getit_2_example)

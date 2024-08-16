# Flutter GetIt
<div align="center">


**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/release/3.0.0-rc.2/README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/release/3.0.0-rc.2/README.md)
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
| isReady                 | Esse atributo indica se todos os middlewares e bindings assincronos foram carregados


O atributo **[routes]** deve ser repassado para o MaterialApp, conforme ilustrado no exemplo abaixo:

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
      modulesRouter: [
        FlutterGetItModuleRouter(
          name: '/Initialize',
          pages:[
            FlutterGetItPageRouter(
              name: '/Landing',
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text('Initializing...'),
                ),
              ),
            ),
          ]
        ),
      ],
      builder: (context, routes, isReady) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/Landing/Initialize',
          routes: routes,
          builder: (context, child) => switch (isReady) {
            true => child ?? const SizedBox.shrink(),
            false => const WidgetLoadDependencies(),
          },
        );
      },
    );
  }
}
```

O exemplo acima demonstra a configuração básica do FGetIt, incluindo o tratamento de carregamento (loader) em middlewares e bindings assíncronos.
Mais abaixo vamos detalhar cada um desses itens.

**Importante:** O Flutter GetIt não substitui as rotas padrão do Flutter; ele aproveita a estrutura existente utilizando o ciclo de vida nativo do Flutter. Essa abordagem mantém a navegação da aplicação intacta, evitando reescritas desnecessárias e prevenindo bugs e problemas indesejados.

Porém para ele ter o controle das dependências você deve registrar as páginas da sua aplicação nos atributos [modulesRouter] conforme o exemplo acima, [pagesRouter] ou [modules] que você verá um pouco mais pra frente.

## FlutterGetItModuleRouter

No exemplo acima, você viu a forma mais simples de implementar uma rota dentro do flutter_getit. Se a sua página for tão simples quanto a nossa página inicial, você pode utilizar a classe de page, adicionando a página e o caminho ao qual ela irá responder.

O primeiro nivel da rota é o **[FlutterGetItModuleRouter]**, ele é responsável por agrupar as rotas de uma determinada área da aplicação, como por exemplo, a área de autenticação, a área de produtos, a área de configurações, etc.

O **[FlutterGetItModuleRouter]** é composto por um **[name]** e um **[pages]**, onde o **[name]** é o nome do módulo e o **[pages]** é uma lista de **[FlutterGetItPageRouter]** ou outros **[FlutterGetItModuleRouter]**.

Você pode olhar o **[FlutterGetItModuleRouter]** como um "Modulo" ou "Sub-Modulo" dentro do sistema de rotas, pondendo criar quantos modulos quiser, e aninhar-los.

Eles serão repassados de forma hierárquica para o modulo ou pagina filho, permitindo que você posso navegar dentro da arvore e se necessario, o FlutterGetIt irá instanciar as Binds.

Vejamos um exemplo de como criar um **[FlutterGetItModuleRouter]**:

```dart
FlutterGetItModuleRouter(
    name: '/Register',
    bindings: [
      Bind.lazySingleton<RegisterController>(
        (i) => RegisterController(),
      ),
    ],
    onInit: (i) => debugPrint('hi by /Register'),
    onDispose: (i) => debugPrint('bye by /Register'),
    pages: [
      FlutterGetItPageRouter(
        name: '/Page',
        builder: (context) => RegisterPage(
          controller: context.get(),
        ),
        bindings: [
          Bind.lazySingleton<RegisterController>(
            (i) => RegisterController(),
          ),
        ],
      ),
      FlutterGetItModuleRouter(
        name: '/ActiveAccount',
        bindings: [
          Bind.lazySingleton<ActiveAccountPageDependencies>(
            (i) => (
              controller: ActiveAccountController(name: 'MyName'),
              validateEmailController:
                  ValidateEmailController(email: 'fgetit@injector'),
            ),
          ),
        ],
        pages: [
          FlutterGetItPageRouter(
            name: '/Page',
            builder: (context) => const ActiveAccountPage(),
            bindings: [],
          ),
        ],
      ),
    ],
  ),
```

Na estrutura acima o **[FlutterGetItModuleRouter]** **[/Register]** possui uma página **[/Page]** e um submodulo **[/ActiveAccount]**, que por sua vez possui uma página **[/Page]**. Se descidir navegar para **[/ActiveAccount/Page]**, o **[FlutterGetIt]** irá instanciar as dependências do **[/ActiveAccount]** e **[/ActiveAccount/Page]** e também do **[/Register]**, pois ele é um **[FlutterGetItModuleRouter]** superior na mesma arvore que **[/ActiveAccount]**.

Um **[FlutterGetItModuleRouter]** pode ter quantas páginas e submodulos quiser, e pode ser aninhado a outros **[FlutterGetItModuleRouter]**. Os atribuitos deste componente são:

| Atributo   | Descrição                                                                                    |
|------------|--------------------------------------------------------------------------------------------- |
| name       | Nome do módulo.                                                                              |
| bindings   | Binds que serão instanciadas e removidas no mesmo tempo de vida do **[module]** que utilizar.|
| onDispose  | Aqui pode executar uma ação antes das Binds serem fechadas e removidas.                      |
| onInit     | Aqui pode executar uma ação antes das Binds serem instanciadas.                              |
| pages      | Páginas ou submódulos que serão instanciados e removidos no mesmo tempo de vida do **[module]** que utilizar. |

## FlutterGetItPageRouter

O **[FlutterGetItPageRouter]** é o componente responsável por criar uma rota de página dentro do seu aplicativo. Ele é composto por um **[name]**, que é o caminho da rota, e um **[builder]**, que é o widget que será exibido na tela e também possui **[Binds]** para inicializar e **[pages]** caso queira criar uma arvore hierárquica de navegação.

```dart
FlutterGetItPageRouter(
          name: '/Landing',
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Initializing...'),
            ),
          ),
        ),
```

No exemplo acima, criamos uma rota chamada **[/Landing]** que exibirá um texto "Initializing..." no centro da tela.

O **[FlutterGetItPageRouter]** também possui um atributo **[bindings]**, que é uma lista de **[Bind]** que serão instanciadas e removidas no mesmo tempo de vida do **[page]** que utilizar.

```dart
FlutterGetItPageRouter(
          name: '/Landing/Initialize',
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Initializing...'),
            ),
          ),
          bindings: [
             Bind.lazySingleton(
              (i) => InitializeController(),
            )
          ],
        ),
```

Dessa forma, o flutter_getit adicionará, durante o carregamento da sua tela, uma instância de InitializeController ao get_it, possibilitando a utilização da sua página. No entanto, é importante destacar que ao sair dessa tela, o flutter_getit eliminará a instância da memória do seu aplicativo, garantindo uma gestão eficiente dos recursos.

O **[FlutterGetItPageRouter]** também possui um metodo **[buildAsync]** que será invocado quando algum binding ou middleware assincrono for encontrado nessa rota'

## Dependências de aplicação

Todo projeto necessita de dependencias que devem ficar ativas pela aplicação toda, ex: RestClient(Dio), Log e muitas outras. Para o FlutterGetIt, você pode facilmente disponibilizar isso. Basta, durante a inicialização [FlutterGetIt], enviar o parâmetro **[bindings]** dentro do **[FlutterGetIt]** na main.

## Exemplo utilizando **[bindings]**

```dart
FlutterGetIt(
      bindings: MyApplicationBindings(),
      builder: (context, routes) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/Landing/Initialize',
          routes: routes,
        );
      },
    );
```
A classe **[MyApplicationBindings]** extende a **[ApplicationBindings]**, veja o exemplo abaixo.
```dart
class MyApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.singletonAsync(
          (i) async => SharedPreferences.getInstance(),
        ),
      ];
}
```

## Atributo **[modules]**

Em projetos grandes, a lista de dependências de uma aplicação pode ser extensa. Para manter o projeto mais organizado, criamos o FlutterGetItModule que deve ser aplicado ao atributo **"modules"**. Com ele, você pode fornecer uma classe para o carregamento das suas dependências e poderá aplicar regras de inicialização como em rotas.

```dart
 FlutterGetIt(
      modules: [
        LandingModule(),
      ],
      builder: (context, routes) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/Landing/Initialize',
          routes: routes,
        );
      },
    );
```

### Veja como criar um modulo:
```dart
class LandingModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Landing';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItModuleRouter> get pages => [
    FlutterGetItModuleRouter(
          name: '/Initialize',
          bindings: [],
          pages: [
            FlutterGetItPageRouter(
              name: '/Page',
              page: (context) => const InitializePage(),
              bindings: [
                Bind.lazySingleton<InitializeController>(
                      (i) => InitializeController(),
                ),
              ],
            ),
          ]
        ),
    FlutterGetItModuleRouter(
          name: '/Presentation',
          bindings: [], 
            pages: [
              FlutterGetItPageRouter(
                name: '/Page',
                page: (context) => const InitializePage(),
                bindings: [
                  Bind.lazySingleton<InitializeController>(
                        (i) => InitializeController(),
                  ),
                ],
              ),
            ]
        ),
        FlutterGetItPageRouter(
          name: '/Simples',
          page: (context) => const InitializePage(),
          bindings: [
            Bind.lazySingleton<InitializeController>(
                  (i) => InitializeController(),
            ),
          ],
        ),
      ];

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}
}
```
Sobre **[moduleRouteName]**:
* Este é nome do seu modulo, suas rotas deve iniciar com está key e terminar com a key de uma rota interna existente em **[pages]**.

Sobre **[bindings]**:
* Aqui fica suas bindings "globais" do modulo, ex repositories. Sempre que uma rota do modulo for chamada, está binds serão verificadas e instanciadas se necessário.

Sobre **[pages]**:
* Aqui fica suas pages internas dos modulo, seguindo as mesma regras mencionada acima sobre **[FlutterGetItModuleRouter]**. É importante saber que a ordem da lista não interfere na utilização.

Sobre **[onInit]** e **[onDispose]**:
* Serão chamados na rota de inicialialização do modulo (entrada e saida), podendo ser qualquer uma dentro de **[pages]**.

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
    return ...;
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
    return ...;
  }
}
```

* Você também poderá usar o **[Injector.getAsync]** para Binds assíncronas, veja mais sobre elas a seguir.

## Tipos de Binds

O flutter_getit suporta todos os outros bindings suportados pelo motor get_it:

Aqui está a tabela formatada em Markdown:

| Bind                   | Descrição                                                                                                                                           |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `Bind.lazySingleton`    | Esse bind vai inicializar a dependência somente quando o usuário chamá-la pela primeira vez. Após isso, ela se tornará um singleton, retornando a mesma instância toda vez que for requisitada. |
| `Bind.lazySingletonAsync` | Esse bind funciona como o `Bind.lazySingleton`, mas sua primeira chamada será assíncrona.                                                           |
| `Bind.singleton`        | Ao contrário do `lazySingleton`, o `singleton` fará a inicialização da instância imediatamente quando a página carregar.                               |
| `Bind.singletonAsync`   | Esse bind funciona como o `Bind.singleton`, mas sua primeira chamada será assíncrona.                                                                |
| `Bind.factory`          | A `factory` faz com que toda vez que você solicitar uma instância para o gerenciador de dependências, ele fornecerá uma nova instância.               |
| `Bind.factoryAsync`     | Esse bind funciona como o `Bind.factory`, mas sua primeira chamada será assíncrona.                                                                  |

## Atributo **[keepAlive]**
* O atributo `keepAlive`, presente nas bindings, instrui o FlutterGetIt a não descartar a classe, mantendo-a em memória durante todo o ciclo de vida da aplicação.

É importante usar esse parâmetro com cautela e somente quando você tiver certeza absoluta do que está fazendo.

# Exemplo Completo

```dart
class MyApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.singleton(
          (i) async => SharedPreferences.getInstance(),
        ),
        Bind.singletonAsync(
          (i) async => SharedPreferences.getInstance(),
        ),
        Bind.lazySingleton(
          (i) async => AsyncTest(),
        ),
        Bind.lazySingletonAsync(
          (i) async => Future.delayed(
            const Duration(seconds: 4),
            () => AsyncTest(),
          ),
        ),
        Bind.factory(
          (i) => MyDeepLink(),
        ),
        Bind.factoryAsync(
          (i) => Future.delayed(
            const Duration(seconds: 4),
            () => MyDeepLink(),
          ),
        ),
      ];
}
```

## Importante sobre **[Binds Async]**
* Através do atalho do **[Injector.]** você pode aguardas suas Binds assíncronas ficarem prontas antes de iniciar qualquer ação. Normalmente usado durante a transição da SplashPage, para carregar dependências assíncronas.

Exemplo:

```dart
class InitializeController with FlutterGetItMixin {
  InitializeController();
  @override
  void dispose() {}

  @override
  void onInit() async {
    await Injector.allReady();
    //Do something
  }
}
```

## Importante sobre **[Bind.factory]** e **[Bind.factoryAsync]**
* A cada solicitação ao FlutterGetIt, a factory retornará uma nova instância do objeto solicitado. No entanto, você pode definir uma **[factoryTag]** no momento de instanciar o objeto. Com isso, o FlutterGetIt atribuirá essa tag ao objeto, tornando-o único na árvore. Dessa forma, ao solicitar o objeto usando a mesma tag, o FlutterGetIt retornará a instância já criada, evitando duplicações e permitindo que o objeto seja chamado em outros locais com a precisão da tag.* Você também pode remover uma Bind baseada na sua **[factoryTag]**.

Exemplo de criação:
```dart
final fGetIt = context.get<FormItemController>(factoryTag: 'UniqueKeyString');

// Agora este objeto esta atribuido a está tag, e em caso de hotReload ou solicitação em outro local, o FlutterGetIt pode identifica-la e não seja gerado um novo Objeto na factory.

//Exemplo em outro controller.
final factoryCriadoNaHomePage = context.get<FormItemController>(factoryTag: 'UniqueKeyString');
```

Exemplo de remoção:
```dart
Injector.unRegisterFactory<FormItemController>(UniqueKeyString);

// Aqui vamos remover todas os Objetos dos tipo T
Injector.unRegisterAllFactories<FormItemController>();
```

### UI e Widgets

* O FlutterGetIt possui um conjunto de ferramentas para ajudar a utilização dos componentes e regras na UI.

# FlutterGetItWidget

| Atributo   | Descrição                                                                                                             |
|------------|-----------------------------------------------------------------------------------------------------------------------|
| `name`     | O id é utilizado para identificação do elemento internamente e na extensão, exemplo "/HomeWidget" ou "WidgetCounter".  |
| `binds`    | Binds que serão instanciadas e removidas no mesmo tempo de vida do **[widget ou page]** que utilizar.                 |
| `onDispose`| Aqui pode executar uma ação antes das Binds serem fechadas e removidas.                                                |
| `onInit`   | Aqui pode executar uma ação logo após as Binds serem iniciadas.                                                        |
| `builder`  | Construção do Widget.                                                                                                 |

Exemplo:
```dart
 FlutterGetItWidget(
      name: id,
      binds: [
        Bind.factory(
          (i) => FormItemController(
            name: 'FormItemController',
          ),
        ),
      ],
      onDispose: () {
        Injector.unRegisterFactory<FormItemController>(id);
      },
      builder: (context) {
        final fGetIt = context.get<FormItemController>(factoryTag: id);
        return Column(
          children: [
            Text(fGetIt.name),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: fGetIt.name,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        );
      },
    );
```

# FlutterGetItView

* O **[FlutterGetItView]** é um atalho que extende **[StatelessWidget]** permitindo que você reduza a quantidade de codigo no widget.
* A utilização proverá uma variavel chamada **[fGetit]** que assumirá o valor repassado <T> no **[FlutterGetItView]**.
 
Exemplo:
```dart
class ActiveAccountPage extends FlutterGetItView<ActiveAccountController> {
  const ActiveAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fGetIt.name),
      ),
      body: ...,
    );
  }
}
```

## Adicionando ciclo de vida aos bindings

### FlutterGetItMixin - Ciclo de vida do Objeto
* O FlutterGetIt oferece o mixin **[FlutterGetItMixin]**, que pode ser aplicado à sua classe, permitindo que o objeto tenha um ciclo de vida completo, com métodos de inicialização e finalização.

| Atributo    | Descrição                                      |
|-------------|------------------------------------------------|
| `onDispose` | Chamado no momento em que o objeto é removido. |
| `onInit`    | Chamado na primeira vez que o objeto é instanciado. |

Exemplo:

```dart
class ActiveAccountController with FlutterGetItMixin {
  final String name;

  ActiveAccountController({required this.name});
  @override
  void onDispose() {}

  @override
  void onInit() {}
}
```

# FlutterGetIt.navigator - Navigator 2.0

* O FlutterGetIt possui suporte ao novigator 2.0, permitindo que instancie modulos e rotas exclusiva para o contexto interno. Para isto basta envolver o "Navigator" com o **[FlutterGetIt.navigator]**.

| Atributo | Descrição
|------|----------
| navigatorName | Nome do navigator para identificação na arvore e extensão.
| bindings | Mesma regra utilizada nas bindings da "main", mas deve estender **[NavigatorBindings]** invés de **[ApplicationBindings]**
| pages | Atribuição de rotas como na "main".
| modules | Atribuição de modulos como na "main".
| builder | Retorna o context e rotas como na "main".

Exemplo:

```dart
 Scaffold(
      body: FlutterGetIt.navigator(
        navigatorName: 'NAVbarProducts',
        bindings: MyNavigatorBindings(),
        modulesRouter: [
          FlutterGetItModuleRouter(
            name: '/Random',
            bindings: [
              Bind.lazySingleton<RandomController>(
                (i) => RandomController('Random by FlutterGetItPageRouter'),
              ),
            ],
          pages: [
              FlutterGetItPageRouter(
                name: '/Page',
                page: (context) => const RandomPage(),
                ),
              ]
          ),
        ],
        modules: [
          HomeModule(),
          DetailModule(),
          AuthModule(),
        ],
        builder: (context, routes) => Navigator(
          key: internalNav,
          initialRoute: '/Home/Page',
          observers: const [],
          onGenerateRoute: (settings) {
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  routes[settings.name]?.call(context) ?? const Placeholder(),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar...
      ...
      ...
```


# Route Outlet

## O que é um RouteOutlet

O "Router Outlet" é um marcador onde o roteador insere o componente correspondente à rota ativa. Esse recurso é extremamente importante em todas as aplicações, pois permite adicionar um componente e carregar páginas com base nas rotas.

## Como utilizá-lo

Para utilizá-lo, basta adicionar o widget **FlutterGetItRouteOutlet** na página onde deseja ter a navegação interna. Nele, você deve configurar a rota inicial (initialRoute) e a chave de navegação. Com isso, toda a navegação registrada no Material App será carregada dentro do Router Outlet.

## Segue um exemplo completo com BottomNavBar: 

```dart
 Scaffold(
      body: FlutterGetItRouteOutlet(
        initialRoute: '/Auth/Login',
        navKey: internalNav,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (_currentIndex != value) {
            switch (value) {
              case 0:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Auth/Login', (_) => false);
              case 1:
                internalNav.currentState?.pushNamedAndRemoveUntil(
                    '/Auth/Register/Page', (_) => false);
              case 2:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/RootNavBar/Root', (_) => false);
                    case 3:
                internalNav.currentState
                    ?.pushNamedAndRemoveUntil('/Landing/Initialize', (_) => false);
            }
            setState(() {
              _currentIndex = value;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.production_quantity_limits,
              color: Colors.blueAccent,
            ),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Custom NavBar',
          ),
           BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Presentation',
          ),
        ],
      ),
    );
```

## Customizando a Animação de Transição

Você também pode personalizar a animação de transição adicionando o atributo **transitionsBuilder**.

```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
  scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
  child: child,
),
```

 
# Projeto com exemplo

[Projeto exemplo](https://github.com/rodrigorahman/getit_flutter/tree/main/example)

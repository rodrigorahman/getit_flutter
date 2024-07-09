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
      pages: [
        FlutterGetItPageRouter(
          name: '/Landing/Initialize',
          page: (context) => const Scaffold(
            body: Center(
              child: Text('Initializing...'),
            ),
          ),
        ),
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
  }
}
```

O Flutter GetIt não reescreve as rotas padrão do Flutter; ele cria uma estrutura utilizando o ciclo de vida nativo do Flutter. Essa abordagem evita a reescrita desnecessária da navegação da aplicação, prevenindo bugs e problemas indesejados

Porém para ele ter o controle das dependências você deve registrar as páginas da sua aplicação nos atributos [pages] conforme o exemplo acima ou [modules] que você verá um pouco mais pra frente.

## FlutterGetItPageRouter

No exemplo acima, você viu a forma mais simples de implementar uma rota dentro do flutter_getit. Se a sua página for tão simples quanto a nossa página inicial, você pode utilizar a classe de page, adicionando a página e o caminho ao qual ela irá responder.

```dart
FlutterGetItPageRouter(
          name: '/Landing/Initialize',
          page: (context) => const Scaffold(
            body: Center(
              child: Text('Initializing...'),
            ),
          ),
        ),
```

Agora, se você precisa controlar alguma dependência logo no carregamento da sua home_page, você pode utilizar o atributo **[bindings]**. Ao adicionar este atributo, é possível especificar a dependência que será utilizada na sua página

```dart
FlutterGetItPageRouter(
          name: '/Landing/Initialize',
          page: (context) => const Scaffold(
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

Você também poderá adicionar rotas "filhas" através do atributo **[pages]**, as quais possuirão a mesma estrutura **[FlutterGetItPageRouter]**.
É importante saber que as **[Bindings]** da rota "mãe" se manterão abertas, o **[FlutterGetIt]** sabe diferencias as **[Bindings]** de cada rota, portando se adicionar um controller a uma rota filha, ele apenas será instaciado ao entrar nesta rota, e removido ao sair da mesma. 

## Dependências de aplicação

Todo projeto necessita de dependencias que devem ficar ativas pela aplicação toda, ex: RestClient(Dio), Log e muitas outras. Para o FlutterGetIt, você pode facilmente disponibilizar isso. Basta, durante a inicialização [FlutterGetIt], enviar o parâmetro **[bindings]** dentro do **[FlutterGetIt]** na main.

## Exemplo utilizando **[bindings]**

```dart
return FlutterGetIt(
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

## Atributo **[modules]

Em projetos grandes, a lista de dependências de uma aplicação pode ser extensa. Para manter o projeto mais organizado, criamos o FlutterGetItModule que deve ser aplicado ao atributo **"modules"**. Com ele, você pode fornecer uma classe para o carregamento das suas dependências e poderá aplicar regras de inicialização como em rotas.

```dart
return FlutterGetIt(
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

Veja como criar um modulo:
```dart
class LandingModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/Landing';

  @override
  List<Bind<Object>> get bindings => [];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Initialize',
          page: (context) => const InitializePage(),
          bindings: [
            Bind.lazySingleton<InitializeController>(
              (i) => InitializeController(),
            ),
          ],
        ),
        FlutterGetItPageRouter(
          name: '/Presentation',
          page: (context) => const PresentationPage(),
          bindings: [],
        ),
      ];

  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {}
}
```
Sobre **[moduleRouteName]**:
* Este é nome do seu modulo, suas rotas deve iniciar com está key e terminar com a key de uma rota interna existente em **[pages]**.

Sobre **[bindings]**:
* Aqui fica suas bindings "globais" do modulo, ex repositories. Sempre que uma rota do modulo for chamada, está binds serão verificadas e instanciadas se necessário.

Sobre **[pages]**:
* Aqui fica suas pages internas dos modulo, seguindo as mesma regras mencionada acima sobre **[FlutterGetItPageRouter]**. É importante saber que a ordem da lista não interfere na utilização.

Sobre **[onInit]** e **[onClose]**:
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

## Tipos de Binds

O flutter_getit suporta todos os outros bindings suportados pelo motor get_it:

| Bind | Descrição
|------|----------
| Bind.lazySingleton | Esse bind vai inicializar a dependência somente quando o usuário chamá-la pela primeira vez. Após isso, ela se tornará um singleton, retornando a mesma instância toda vez que for requisitada.
| Bind.lazySingletonAsync | Esse bind funciona como o "Bind.lazySingleton", mas sua primeira chamada será assíncrona.
| Bind.singleton | Ao contrário do lazySingleton, o singleton fará a inicialização da instância imediatamente quando a página carregar.
| Bind.singletonAsync | Esse bind funciona como o "Bind.singleton", mas sua primeira chamada será assíncrona.
| Bind.factory | A factory faz com que toda vez que você solicitar uma instância para o gerenciador de dependências, ele fornecerá uma nova instância.
| Bind.factoryAsync | Esse bind funciona como o "Bind.factory", mas sua primeira chamada será assíncrona.

# Atributo **[keepAlive]**
* Este atributo presente nas bindings, determinará que o FlutterGetIt não deixe que outros controllers ou modulos a removam, tornando-a permanente no ciclo de vida da app.

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

## Importante sobre **[Bind.factory]** e **[Bind.factoryAsync]**
* A cada solicitação ao FlutterGetIt a factory retornará uma nova instancia do objeto solicitado, mas você pode definir uma **[factoryTag]** no momento de intanciar, assim o FlutterGetIt atribuirá essa tag ao Objeto tornando-o unico na arvore, podendo assim evitar duplicações e podendo ser chamdado em outros locais com a precisão da tag.
* Você também pode remover uma Bind baseada na sua **[factoryTag]**.

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
```

### UI e Widgets

* O FlutterGetIt possui um conjunto de ferramentas para ajudar a utilização dos componentes e regras na UI.

# FlutterGetItWidget

| Atributo | Descrição
|------|----------
| name | O id é utilizado para identificação do elemento internamente e na extensão, exemplo "/HomeWidget" || "WidgetCounter".
| binds | Binds que serão instanciadas e removidas no mesmo tempo de vida do **[widget || page]** que utilizar. 
| onDispose | Aqui pode executar uma ação antes das Binds serem fechadas e removidas.
| builder | Construção do Widget.

Exemplo:
```dart
return FlutterGetItWidget(
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

* O **[FlutterGetItView]** é um atralho que extende **[StatelessWidget]** permitindo que você reduza a quantidade de codigo no widget.
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

# FlutterGetItMixin - Ciclo de vida do Objeto

* O FlutterGetIt possui o mixin **[FlutterGetItMixin]** que lhe permite aplica-lo em sua classe, fazendo com que o Objeto para a ter um ciclo de inicialização e finalização.

| Atributo | Descrição
|------|----------
| dispose | Chamado no momento que o Objeto é removido.
| onInit | Chamado na primeira vez que o Objeto é instanciado.

Exemplo:

```dart
class ActiveAccountController with FlutterGetItMixin {
  final String name;

  ActiveAccountController({required this.name});
  @override
  void dispose() {}

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
return Scaffold(
      body: FlutterGetIt.navigator(
        navigatorName: 'NAVbarProducts',
        bindings: MyNavigatorBindings(),
        pages: [
          FlutterGetItPageRouter(
            name: '/RandomPage',
            page: (context) => const RandomPage(),
            bindings: [
              Bind.lazySingleton<RandomController>(
                (i) => RandomController('Random by FlutterGetItPageRouter'),
              ),
            ],
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




 
## Projeto com exemplo

[Projeto exemplo](https://github.com/rodrigorahman/flutter_getit_2_example)

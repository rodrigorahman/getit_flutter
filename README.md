# Flutter GetIt
<div align="center">


**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/refactory_2_0_0/README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/refactory_2_0_0/README.md)
</div>

This package is an essential tool for efficient dependency management in the lifecycle of your Flutter project. It provides robust support for page control, including route management, and the flexibility to work with modules.

## **Key Features:**

**Dynamic Dependency Control:** Leveraging the powerful get_it engine, this package automatically registers and removes dependencies as needed, optimizing performance and ensuring the efficiency of your application.

**Flexible Modules:** Embrace the modularity of your code. This package makes it easy to create and manage modules, making your project more organized and easy to maintain.

Additional Benefits:

**Automatic Dependency Cleanup:** The package takes care of removing dependencies when they are no longer needed, ensuring efficient management of your application's resources.

>Flutter GetIt offers various approaches to control routes and load bindings for your application, including page routes, builders, and modules. You will see details of each of them later on.


# Getting Started

## Setting up flutter_getit

Configuring Flutter GetIt is done by adding a widget around your MaterialApp. By including the widget and implementing the builder attribute, three attributes will be passed to you:

| Field                   | Description
|-------------------------|-------------
| context                 | BuildContext
| routes                  | A map that should be added to the routes tag of MaterialApp or CupertinoApp
| flutterGetItNavObserver | This attribute is a NavigatorObserver and should be added to the **navigatorObservers** attribute of MaterialApp.
|

The **[routes]** and **[flutterGetItNavObserver]** attributes should be forwarded to the MaterialApp, as illustrated in the example below:

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

Flutter GetIt does not override Flutter's default routes; it creates a structure using Flutter's native lifecycle. This approach avoids unnecessary rewriting of application navigation, preventing bugs and undesired issues.

However, for it to have control over dependencies, you must register your application's pages in the **[pages]** attribute as shown in the example above, or **[modules]** as you will see a bit later.

## FlutterGetItPageBuilder

In the example above, you saw the simplest way to implement a route within flutter_getit. If your page is as simple as our initial page, you can use the builder class, adding the page and the path to which it will respond.

```dart
FlutterGetItPageBuilder(
  // Define a página que será exibida quando a rota for acessada
  page: (context) => const MyHomePage(title: 'home'),
  // Define o caminho da rota
  path: '/',
),
```

Now, if you need to control a dependency right when your home_page is loaded, you can use the **binding** attribute. By adding this attribute, you can specify the dependency that will be used on your page.

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

This way, flutter_getit will add, during the loading of your screen, an instance of PageXController to get_it, enabling the use of your page. However, it's essential to note that upon leaving this screen, flutter_getit will remove the instance from your application's memory, ensuring efficient resource management.

## Application Dependencies

Every project requires dependencies that should stay active throughout the entire application, e.g., RestClient(Dio), Log, and many others. For FlutterGetIt, you can easily make these available. Just, during the initialization [FlutterGetIt], provide the parameter [bindingsBuilder] or [bindings].

## Example using **[bindingsBuilder]**

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

## Attribute [bindings]

In large projects, the list of application dependencies can be extensive. To keep the project more organized, I suggest using the **"bindings"** attribute. With it, you can provide a class for loading your dependencies.

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

## Retrieving Instance

There are two ways to retrieve an instance from flutter_getit. One of them is through the [Injector] class, and the other is through an extension added to the BuildContext using [context.get].

```dart
Injector.get<ServiceForApplication>();

// ou

context.get<ServiceForApplication>();
```

### Example using ***[context.get]***


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

### Example using Injector 

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

## It doesn't stop there

With just these steps, you can already use Flutter GetIt, but there are many more features available.

Keeping your project organized is always the best approach, providing greater ease during maintenance. With that in mind, we added support for routes and modules in the package, offering an even more robust and structured experience.

# Routes

With the [FlutterGetItPageBuilder] class, you are already working with managed routes, but you can make your project even more organized using the **[FlutterGetItPageRouter]** class.

## FlutterGetItPageRouter

This class is responsible for defining routes in your application. Here's an example:

| Method | Description
|--------|-----------
| bindings | A method where you declare each of your dependencies
| routeName | A method where you should return the path of your route
| view | A method that returns the widget representing your Stateless or Stateful Widget (your page).

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
In the example above, we chose not to create a simple route using the builder. Instead, we created a class that represents our route. In this class, you define the dependencies of this route [bindings], the name of the route [routeName], which will be accessed by the Flutter Navigator, and the [view], which is the method that returns the widget representing your StatelessWidget or StatefulWidget.

# Configuring your route

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

# Modules

Starting from version 2.0, flutter_getit also supports modules.

To use the module concept of flutter_getit, you should first create your class representing your module by extending the [FlutterGetItModule] class.

| Method             | Description
|--------------------|-------------
| moduleRouteName    | In this getter, you should provide the base route for your module. This value will be concatenated with the routes of the pages (Always start with /).
| bindings           | In this getter, you should return the bindings you want to add to the page, and get_it_flutter will take care of the rest.
| pages              | In this getter, you should return a map with the routes of this module. In the map value, you should return a function that, as an attribute, receives the context (BuildContext). The return of this function should be a widget, which can be a simple page or [FlutterGetItModulePageRouter].

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

Let's start with bindings. This getter works exactly like the others; the difference lies in the lifecycle. A binding within a module will only be removed when the user exits the module as a whole. For example:

If the user enters the screen ***/auth/login***, it means they entered the module ***/auth*** on the page ***/login***. If the user clicks on a link that goes to the screen ***/auth/register***, flutter_getit will understand that the user is going to the same module and will not remove the dependencies of the module ***/auth***. It will only remove the dependencies of the module ***/auth*** when the user exits the module and goes to another, such as ***/products/***.

## Configuring a module

To configure a module, simply add the attribute modules to [FlutterGetIt]:


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

And automatically, flutter_getit will create the routes ***/auth/login*** and ***/auth/register***.

## Module's Differentiator with [FlutterGetItModulePageRouter]

Working with modules may occasionally require declaring controllers or specific dependencies that will be used exclusively on one of the module's pages. An example of this is controllers, often associated with a single page. However, some packages usually require you to declare the controller instance within the module, as exemplified below:

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

Unlike other approaches, flutter_getit allows the login and registration controllers to remain active only when needed.

## FlutterGetItModulePageRouter

The [FlutterGetItModulePageRouter] class helps you with that. See the example:

Below, we created a LoginPageRoute class where we declared the bindings and the view that will be presented.

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

Now, in our AuthModule, in the login route, we no longer point directly to the LoginPage but to the route [LoginPageRoute].

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

This approach allows the flutter_getit mechanism to recognize these dependencies as distinct entities, loading the LoginController only when the corresponding screen is active and removing it when the screen is unloaded. This prevents the creation of unnecessary instances in your application, contributing to more efficient resource management.

## Types of Binds

So far, you've only seen one type of binding, **Bind.lazySingleton**. However, flutter_getit supports all other bindings supported by the get_it engine:

These possibilities are three:

| Bind | Description
|------|----------
| Bind.lazySingleton| This bind will initialize the dependency only when the user calls it for the first time. After that, it becomes a singleton, returning the same instance every time it is requested.
| Bind.singleton | Unlike lazySingleton, singleton initializes the instance immediately when the page loads.
| Bind.factory | The factory ensures that every time you request an instance from the dependency manager, it will provide a new instance.

### Complete Example

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

## Different Registration Forms

### Lazy Singleton (Bind.lazySingleton)

```dart
    Bind.lazySingleton((i) => HomeController())
```

Lazy Singleton ensures that every time a new instance is requested from the dependency manager, it provides the same instance. However, unlike singleton, this Bind does not initialize the instance immediately when the page loads; it will be created only when requested for the first time.

#### Singleton (Bind.singleton)


```dart
    Bind.singleton((i) => HomeController())
```

Singleton ensures that every time a new instance is requested from the dependency manager, it provides the same instance.

> **Note:** Bind.singleton has the characteristic of initializing the class immediately when the page loads.

### Factory (Bind.factory)

```dart
    Bind.factory((i) => HomeController())
```

A factory ensures that every time you request an instance from the dependency manager, it provides a new instance.


Here's the translated markdown:

# Router Outlet

## What is a Router Outlet

The "Router Outlet" is a placeholder where the router inserts the component corresponding to the active route. This feature is extremely important in all applications as it allows for the addition of a component and the loading of pages based on the routes.

## How to Use It

To use it, simply add the **FlutterGetItRouterOutlet** widget on the page where you want to have internal navigation. You should configure the initial route (`initialRoute`) and the navigation key (`navKey`). This way, all the navigation registered in the Material App will be loaded within the Router Outlet.

## Here's a Complete Example with BottomNavBar:

```dart
Scaffold(
  body: FlutterGetItRouterOutlet(
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

## Customizing the Transition Animation

You can also customize the transition animation by adding the **transitionsBuilder** attribute.

```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
  scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
  child: child,
),
```

# Project with example

[Project with example](https://github.com/rodrigorahman/flutter_getit_2_example)

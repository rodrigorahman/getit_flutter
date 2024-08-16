# Flutter GetIt
<div align="center">


**Languages:**

[![Portuguese](https://img.shields.io/badge/Language-Portuguese-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/release/3.0.0-rc.2/README.pt-br.md)
[![English](https://img.shields.io/badge/Language-English-red?style=for-the-badge)](https://github.com/rodrigorahman/getit_flutter/blob/release/3.0.0-rc.2/README.md)
</div>

This package is an essential tool for efficient dependency management in your Flutter project's lifecycle. It offers robust support for page control, including route management and the flexibility to work with modules.

## **Key Features:**

**Dynamic Dependency Control:** Utilizing the powerful get_it mechanism, this package automatically registers and removes dependencies as needed, optimizing performance and ensuring your application's efficiency.

**Flexible Modules:** Take advantage of your code's modularity. This package makes it easy to create and manage modules, keeping your project organized and easy to maintain.

Additional Benefits:

**Automatic Dependency Cleanup:** The package automatically removes dependencies when they are no longer needed, ensuring efficient resource management for your application.


>Flutter GetIt offers various approaches to controlling routes and loading your application's bindings, including page routes, builders, and modules. You will see details of each of them later on.


# Getting Started

## Configuring flutter_getit

Setting up Flutter GetIt is done by adding a widget around your MaterialApp. By including the widget and implementing the builder attribute, three attributes will be passed to you:

| Field                   | Description
|-------------------------|-------------
| context                 | BuildContext
| routes                  | A map that should be added to the routes tag of the MaterialApp or CupertinoApp
| isReady                 | This attribute indicates whether all asynchronous middlewares and bindings have been loaded


The **[routes]** attribute should be passed to the MaterialApp, as illustrated in the example below:

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

The example above demonstrates the basic configuration of FGetIt, including handling loading (loader) in asynchronous middlewares and bindings.
Further down, we will detail each of these items.

**Important:** Flutter GetIt does not replace Flutter's standard routes; it leverages the existing structure using Flutter's native lifecycle. This approach keeps the application's navigation intact, avoiding unnecessary rewrites and preventing bugs and unwanted issues.

However, for it to control dependencies, you must register your application's pages in the [modulesRouter] attribute as shown in the example above, [pagesRouter], or [modules], which you will see a little further on.

## FlutterGetItModuleRouter

In the example above, you saw the simplest way to implement a route within flutter_getit. If your page is as simple as our initial page, you can use the page class, adding the page and the path it will respond to.

The first level of the route is **[FlutterGetItModuleRouter]**, which is responsible for grouping the routes of a specific area of the application, such as the authentication area, the products area, the settings area, etc.

**[FlutterGetItModuleRouter]** consists of a **[name]** and **[pages]**, where **[name]** is the name of the module and **[pages]** is a list of **[FlutterGetItPageRouter]** or other **[FlutterGetItModuleRouter]**.

You can think of **[FlutterGetItModuleRouter]** as a "Module" or "Sub-Module" within the routing system, allowing you to create as many modules as you want and nest them.

They are passed hierarchically to the child module or page, allowing you to navigate within the tree, and if necessary, FlutterGetIt will instantiate the Binds.

Let's look at an example of how to create a **[FlutterGetItModuleRouter]**:

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

In the structure above, the **[FlutterGetItModuleRouter]** **[/Register]** has a page **[/Page]** and a submodule **[/ActiveAccount]**, which in turn has a page **[/Page]**. If you decide to navigate to **[/ActiveAccount/Page]**, **[FlutterGetIt]** will instantiate the dependencies of **[/ActiveAccount]** and **[/ActiveAccount/Page]** and also of **[/Register]**, as it is a superior **[FlutterGetItModuleRouter]** in the same tree as **[/ActiveAccount]**.

A **[FlutterGetItModuleRouter]** can have as many pages and submodules as desired and can be nested with other **[FlutterGetItModuleRouter]**. The attributes of this component are:

| Attribute  | Description                                                                                  |
|------------|----------------------------------------------------------------------------------------------|
| name       | Module name.                                                                                 |
| bindings   | Binds that will be instantiated and removed in the same lifecycle as the **[module]** used.  |
| onDispose  | Here you can execute an action before the Binds are closed and removed.                      |
| onInit     | Here you can execute an action before the Binds are instantiated.                            |
| pages      | Pages or submodules that will be instantiated and removed in the same lifecycle as the **[module]** used. |

## FlutterGetItPageRouter

**[FlutterGetItPageRouter]** is the component responsible for creating a page route within your application. It consists of a **[name]**, which is the path of the route, and a **[builder]**, which is the widget that will be displayed on the screen and also has **[Binds]** to initialize and **[pages]** if you want to create a hierarchical navigation tree.

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

In the example above, we created a route called **[/Landing]** that will display the text "Initializing..." at the center of the screen.

**[FlutterGetItPageRouter]** also has a **[bindings]** attribute, which is a list of **[Bind]** that will be instantiated and removed in the same lifecycle as the **[page]** used.

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

In this way, flutter_getit will add, during your screen's loading, an instance of InitializeController to get_it, enabling the use of your page. However, it is important to note that when leaving this screen, flutter_getit will remove the instance from your application's memory, ensuring efficient resource management.

**[FlutterGetItPageRouter]** also has a **[buildAsync]** method that will be invoked when any asynchronous binding or middleware is found on this route.

## Application Dependencies

Every project requires dependencies that need to remain active throughout the application, such as RestClient (Dio), Log, and many others. For FlutterGetIt, you can easily make these available. During the initialization of **[FlutterGetIt]**, simply pass the **[bindings]** parameter within **[FlutterGetIt]** in the main function.

## Example using **[bindings]**

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
The **[MyApplicationBindings]** class extends **[ApplicationBindings]**, as shown in the example below.
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

## **[modules]** Attribute

In large projects, the list of application dependencies can be extensive. To keep the project more organized, we created FlutterGetItModule, which should be applied to the **"modules"** attribute. With it, you can provide a class for loading your dependencies and apply initialization rules, similar to routes.

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

### How to Create a Module:

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
          name: '/Simple',
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

About **[moduleRouteName]**:
* This is the name of your module; your routes should start with this key and end with the key of an existing internal route in **[pages]**.

About **[bindings]**:
* This is where your module's "global" bindings are placed, such as repositories. Whenever a module route is called, these bindings will be checked and instantiated if necessary.

About **[pages]**:
* This is where your module's internal pages are defined, following the same rules mentioned above about **[FlutterGetItModuleRouter]**. It is important to note that the order of the list does not affect usage.

About **[onInit]** and **[onDispose]**:
* These will be called at the initialization and disposal of the module (entry and exit), which can be any within **[pages]**.

## Retrieving an Instance

There are two ways to retrieve an instance from flutter_getit. One is through the [Injector] class, and the other is through an extension added to BuildContext using [context.get].

```dart
Injector.get<ServiceForApplication>();

// or

context.get<ServiceForApplication>();
```

### Example Using ***[context.get]***

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Calling the BuildContext extension
    var service = context.get<ServiceForApplication>();
    return ...;
  }
}
```

### Example Using Injector

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

* You can also use **[Injector.getAsync]** for asynchronous Binds; see more about them below.

Here's the translation of the provided text:

## Bind Types

Flutter_getit supports all other bindings supported by the get_it engine:

Here is the table formatted in Markdown:

| Bind                   | Description                                                                                                                                           |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `Bind.lazySingleton`    | This bind will initialize the dependency only when the user calls it for the first time. After that, it will become a singleton, returning the same instance every time it is requested. |
| `Bind.lazySingletonAsync` | This bind works like `Bind.lazySingleton`, but its first call will be asynchronous.                                                           |
| `Bind.singleton`        | Unlike `lazySingleton`, `singleton` will initialize the instance immediately when the page loads.                               |
| `Bind.singletonAsync`   | This bind works like `Bind.singleton`, but its first call will be asynchronous.                                                                |
| `Bind.factory`          | A `factory` ensures that every time you request an instance from the dependency manager, it will provide a new instance.               |
| `Bind.factoryAsync`     | This bind works like `Bind.factory`, but its first call will be asynchronous.                                                                  |

## **[keepAlive]** Attribute
* The `keepAlive` attribute, present in bindings, instructs FlutterGetIt not to discard the class, keeping it in memory throughout the application's lifecycle.

It's important to use this parameter cautiously and only when you are absolutely sure of what you are doing.

# Complete Example

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

## Important Information About **[Async Binds]**
* Through the **[Injector.]** shortcut, you can wait for your asynchronous Binds to be ready before starting any action. This is usually used during the transition from the SplashPage to load asynchronous dependencies.

Example:

```dart
class InitializeController with FlutterGetItMixin {
  InitializeController();
  @override
  void dispose() {}

  @override
  void onInit() async {
    await Injector.allReady();
    // Do something
  }
}
```

## Important Information About **[Bind.factory]** and **[Bind.factoryAsync]**
* Each time you request an instance from FlutterGetIt, the factory will return a new instance of the requested object. However, you can define a **[factoryTag]** when instantiating the object. With this, FlutterGetIt will assign this tag to the object, making it unique in the tree. This way, when you request the object using the same tag, FlutterGetIt will return the already created instance, avoiding duplications and allowing the object to be called in other locations with the precision of the tag. You can also remove a Bind based on its **[factoryTag]**.

Example of creation:
```dart
final fGetIt = context.get<FormItemController>(factoryTag: 'UniqueKeyString');

// Now this object is assigned to this tag, and in case of hotReload or request in another location, FlutterGetIt can identify it and prevent a new Object from being generated in the factory.

// Example in another controller.
final factoryCreatedInHomePage = context.get<FormItemController>(factoryTag: 'UniqueKeyString');
```

Example of removal:
```dart
Injector.unRegisterFactory<FormItemController>(UniqueKeyString);

// Here we will remove all objects of type T
Injector.unRegisterAllFactories<FormItemController>();
```

### UI and Widgets

* FlutterGetIt provides a set of tools to assist in using components and rules in the UI.

# FlutterGetItWidget

| Attribute   | Description                                                                                                             |
|------------|-----------------------------------------------------------------------------------------------------------------------|
| `name`     | The id is used for identifying the element internally and in the extension, for example, "/HomeWidget" or "WidgetCounter".  |
| `binds`    | Binds that will be instantiated and removed in the same lifecycle as the **[widget or page]** that uses them.                 |
| `onDispose`| Here you can execute an action before the Binds are closed and removed.                                                |
| `onInit`   | Here you can execute an action right after the Binds are initiated.                                                        |
| `builder`  | Widget construction.                                                                                                 |

Example:
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

* **[FlutterGetItView]** is a shortcut that extends **[StatelessWidget]**, allowing you to reduce the amount of code in the widget.
* Using it will provide a variable called **[fGetit]** that will take the value passed <T> in **[FlutterGetItView]**.
 
Example:
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

## Adding Lifecycle to Binds

### FlutterGetItMixin - Object Lifecycle
* FlutterGetIt offers the **[FlutterGetItMixin]** mixin, which can be applied to your class, allowing the object to have a complete lifecycle, with initialization and finalization methods.

| Attribute    | Description                                      |
|-------------|------------------------------------------------|
| `onDispose` | Called when the object is removed. |
| `onInit`    | Called the first time the object is instantiated. |

Example:

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

* FlutterGetIt supports Navigator 2.0, allowing you to instantiate modules and routes exclusively for the internal context. To do this, simply wrap the "Navigator" with **[FlutterGetIt.navigator]**.

| Attribute | Description
|------|----------
| navigatorName | Navigator name for identification in the tree and extension.
| bindings | Same rules used for main bindings, but must extend **[NavigatorBindings]** instead of **[ApplicationBindings]**.
| pages | Assignment of routes as in the "main".
| modules | Assignment of modules as in the "main".
| builder | Returns the context and routes as in the "main".

Example:

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

## What is a RouteOutlet

The "Router Outlet" is a marker where the router inserts the component corresponding to the active route. This feature is extremely important in all applications as it allows you to add a component and load pages based on routes.

## How to Use It

To use it, simply add the **FlutterGetItRouteOutlet** widget to the page where you want to have internal navigation. In it, you should configure the initial route (initialRoute) and the navigation key. With this, all navigation registered in the Material App will be loaded within the Router Outlet.

## Here is a complete example with BottomNavBar:

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

## Customizing the Transition Animation

You can also customize the transition animation by adding the **transitionsBuilder** attribute.

```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
  scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
  child: child,
),
```

 
# Example Project

[Example Project](https://github.com/rodrigorahman/getit_flutter/tree/main/example)
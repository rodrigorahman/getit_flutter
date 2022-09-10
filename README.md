## GetIt Flutter

Projeto auxiliar para realizar o register e o unregister na navegação da página

## Como utilizar

## Crie uma classe extendendo GetItPageRoute adicione os bindings (classes que serão adicionadas no getit) e a sua view

```dart
class LoginRoute extends GetItPageRoute {
  @override
  List<Bind> get bindings => [
        Bind.lazy<AuthRepository>(
          (i) => AuthRepositoryImpl(restClient: i()),
        )
      ];

  const LoginRoute({super.key});

  @override
  WidgetBuilder get view => (context) => LoginPage(
        presenter: context.get(),
      );
}
```


## No MaterialApp adicione sua rota normal porém direcionando para o loginroute

```dart
MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      '/': (context) => const LoginRoute(),
    },
);
```

## Caso queira recuperar a instancia utilize o Injetor do flutter_getit

```dart
Injector().get<AuthRepository>();
``` 

## Caso tenha o BuildContext na mão você pode utilizar o get direto dele
```
context.get<AuthRepository>();
```
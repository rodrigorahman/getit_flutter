# Versions

## 3.0.0
- **Breaking Change**: For existing users, please review the detailed in the documentation.

### Major Changes

- Complete package rewrite to support modular architecture.

### Core Changes
- Removed `FlutterGetItNavigatorObserver` on builder.
- The `pages` now expect the new `FlutterGetItModuleRouter`.
- New named constructor called `.navigator` to create a new instance of `FlutterGetIt` for navigator 2.0.

### Module Changes
- The `FlutterGetItModule` now has a new method `onInit` that is called when the module is initialized and a new method `onDispose` that is called when the module is disposed.

### Binds Changes
- News methods, as `singletonAsync`, `factoryAsync`, `lazySingletonAsync`
- New system of factory named, able to create and identify the factory by name.
- New `keepAlive` method to keep the instance alive even after the module is disposed.

### New mixin
- `FlutterGetItModuleMixin` is a mixin that allows you to use the `onInit` and `onDispose` methods in your class.

### Widgets Changes
- New `FlutterGetItView` to automatically inject the object into the widget.
- New `FlutterGetItWidget` to create a widget with lifecycle methods as `onInit` and `onDispose`, and allow to inject the object into the widget.

## 2.0.0
Aprimorando a apresentação e a clareza do texto da versão 2.0.0:

## Version 2.0.0 Highlights

### Major Changes
- **Breaking Change**: For existing users, please review the detailed in the documentation.
- Complete package rewrite to support modular architecture.

### Enhancements
- `ApplicationBindings` are now included in the export list for improved integration.
- A significant update to the documentation, including an English version for broader accessibility.
- Revised the example to align with version 2.0 standards.

### Technical Improvements
- Package description updated to comply with the 180-character limit rule.
- Integration of `flutter_getit` into DevTools, allowing for effective visualization of existing instances.
- Enhanced DevTools extension layout for better user experience.

### Fixes
- Resolved an initialization failure caused by the absence of binding (either binding or bindingBuilder) in FlutterGetItConfig.
- Eliminated redundant injector in routes, utilizing the existing context injector for efficiency.

### Documentation and Metadata
- Expanded project documentation, focusing on clarity and comprehensiveness.
- Enhanced pubspec.yaml with additional tags and topics to facilitate easier discovery on pub.dev.
- License transitioned from Apache-2 to MIT, reflecting changes in licensing preferences.

### Development Tool Adjustments
- Implemented `.pubignore` in DevTools for optimized performance.
- Excluded the /build folder from the extension to streamline the development process.

### New Features
- Introduced a new method for registering permanent bindings under a specific key (FlutterGetItBindingRegister), adding flexibility and control for developers.

This comprehensive update in version 2.0.0 aims to enhance usability, streamline integration, and expand accessibility, reflecting our commitment to continuous.


## 2.0.0-dev.13
- feat: Implement method for permanent binding registration under specific key (FlutterGetItBindingRegister)

## 2.0.0-dev.12
- fix: remove injector in routes, injector already within the context

## 2.0.0-dev.11
- feat: Add getter Injector in routes

## 2.0.0-dev.10
- fix: Error due to no binding (either binding or bindingBuilder) being sent. The assertion in FlutterGetItConfig caused the initialization to fail

## 2.0.0-dev.9
- feat: changed layout devtools extension

## 2.0.0-dev.8
- fix: Exclude /build to extension

## 2.0.0-dev.7
- fix: added .pubignore um devtools

## 2.0.0-dev.6
- feat: Added `flutter_getit` to DevTools, enabling the visualization of existing instances through DevTools.

## 2.0.0-dev.5
- chore: Added tags and topics in pubspec.yaml to facilitate the search in pub.dev.
- chore: Change license from Apache-2 to MIT 

## 2.0.0-dev.4
- fix: updated package description to adhere to the rule of a maximum of 180 characters

## 2.0.0-dev.3
- docs: Added documentation in English
- docs: Improvements to the project documentation
- fix: Changing example to version 2.0 

## 2.0.0-dev.2
- Fix: adicionado ApplicationBindings no export
- docs: Documentação atualizada (Versao 1)

## 2.0.0-dev.1
- Reescrita do package com suporte a módulos

- **Break Change**:
    Leia a documentação e caso você já tenha implementado no seu projeto veja a documentação de migração da versão 1 para a versão 2

## 1.2.1

* Suporte a secondary register, esse recurso permite que vc coloque no binding um objeto que já está registrado na arvore de componentes
evitando assim a duplicidade e erro do getit Object is already registeres inside GetIt;


## 1.2.0

* Adicionando FlutterGetItApplicationBinding

## 1.1.1

* Removendo Warnings

## 1.1.0

* Criação de 3 novos tipos de Widget (FlutterGetItPageRoute, FlutterGetItWidget, FlutterGetItPageBuilder) cada um com seu objetivo

* Descontinuamos a classe GetItPageRoute deve ser substituida pela classe FlutterGetItPageRoute (**ATENÇÃO: Essa classe será removida na próxima versão**)

* Refactory no Injector antes você precisava chama com Injector().get, agora deve ser utilizado com Injector.get.

* Acerto no dartdoc

* Acertos na documentação

* Adicionado exemplo de implementação na documentação

## 1.0.0

* Release 1.0.0

## 0.0.3

* Change description and name project

## 0.0.2

* Add documentation

## 0.0.1

* Beta Version

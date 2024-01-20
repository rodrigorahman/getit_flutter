# Versions

## 2.0.0-dev.10
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

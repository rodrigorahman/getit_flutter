import 'dart:developer';

import 'package:example/application/middleware/auth_middleware.dart';
import 'package:example/src/landing/initialize_controller.dart';
import 'package:example/src/landing/initialize_page.dart';
import 'package:example/src/landing/presentation_page.dart';
import 'package:flutter_getit/flutter_getit.dart';

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
          middlewares: [
            AuthMiddleware(),
          ],
          bindings: [
            Bind.singletonAsync<PresentationRepository>(
              (i) => Future.delayed(
                const Duration(seconds: 1),
                () => PresentationRepository(),
              ),
              keepAlive: true,
            ),
            Bind.singleton<PresentationController>(
              (i) => PresentationController(
                repository: i(),
              ),
              dependsOn: [PresentationRepository],
            ),
            Bind.lazySingletonAsync<PresentationDatabase>(
              (i) => Future.delayed(
                const Duration(seconds: 1),
                () => PresentationDatabase(),
              ),
            ),
          ],
        ),
      ];

  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}
}

class PresentationController with FlutterGetItMixin {
  final PresentationRepository repository;
  PresentationController({required this.repository});

  @override
  void onDispose() {}

  @override
  void onInit() {}
}

class PresentationRepository {}

class PresentationDatabase with FlutterGetItMixin {
  @override
  void onDispose() {
    log('Dispose PresentationDatabase');
  }

  @override
  void onInit() {
    log('Init PresentationDatabase');
  }
}

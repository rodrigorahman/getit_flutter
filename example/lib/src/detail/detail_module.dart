import 'package:example/src/detail/detail_controller.dart';
import 'package:example/src/detail/detail_page.dart';
import 'package:example/src/detail/detail_repository.dart';
import 'package:example/src/detail/detail_super_controller.dart';
import 'package:example/src/detail/detail_super_page.dart';
import 'package:example/src/detail/internal/detail_internal_child.dart';
import 'package:example/src/detail/internal/detail_internal_page.dart';
import 'package:example/src/detail/internal/detail_internal_repository.dart';
import 'package:example/src/detail/widget/form_item_controller.dart';
import 'package:example/src/home/home_controller.dart';
import 'package:example/src/loader/load_dependencies.dart';
import 'package:flutter_getit/flutter_getit.dart';

class DetailModule extends FlutterGetItModule {
  @override
  void onDispose(Injector i) {}

  @override
  void onInit(Injector i) {}

  @override
  String get moduleRouteName => '/Detail';

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => DetailRepository(),
        ),
        Bind.singleton(
          (i) => HomeController(),
          tag: 'HomeController2',
        ),
      ];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItModuleRouter(
          name: '/Factories',
          bindings: [
            Bind.factory(
              (i) => FormItemController(
                name: 'FormItemController',
              ),
            ),
          ],
          pages: [
            FlutterGetItPageRouter(
              name: '/One',
              page: (context, isReady, loader) => switch (isReady) {
                true => DetailPage(
                    controller: context.get(),
                  ),
                false => loader ?? const WidgetLoadDependencies(),
              },
              bindings: [
                Bind.lazySingleton<DetailController>(
                  (i) => DetailController(),
                ),
              ],
              pages: [
                FlutterGetItModuleRouter(
                  name: '/Internal',
                  bindings: [
                    Bind.lazySingleton<DetailInternalRepository>(
                      (i) => DetailInternalRepository(),
                    ),
                  ],
                  pages: [
                    FlutterGetItPageRouter(
                      name: '/Page',
                      page: (context, isReady, loader) => switch (isReady) {
                        true => DetailInternalPage(
                            repository: context.get(),
                          ),
                        false => loader ?? const WidgetLoadDependencies(),
                      },
                      bindings: [],
                      pages: [
                        FlutterGetItPageRouter(
                          name: '/Child',
                          page: (context, isReady, loader) => switch (isReady) {
                            true => DetailInternalChild(
                                repository: context.get(),
                              ),
                            false => loader ?? const WidgetLoadDependencies(),
                          },
                          bindings: [],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            FlutterGetItPageRouter(
              name: '/Two',
              page: (context, isReady, loader) => switch (isReady) {
                true => DetailSuperPage(
                    controller: context.get(),
                  ),
                false => loader ?? const WidgetLoadDependencies(),
              },
              bindings: [
                Bind.lazySingleton<DetailSuperController>(
                  (i) => DetailSuperController(),
                ),
              ],
            ),
          ],
        ),
      ];
}

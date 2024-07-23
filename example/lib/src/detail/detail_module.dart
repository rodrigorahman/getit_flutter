import 'package:example/src/detail/detail_controller.dart';
import 'package:example/src/detail/detail_page.dart';
import 'package:example/src/detail/detail_repository.dart';
import 'package:example/src/detail/detail_super_controller.dart';
import 'package:example/src/detail/detail_super_page.dart';
import 'package:example/src/detail/widget/form_item_controller.dart';
import 'package:flutter_getit/flutter_getit.dart';

class DetailModule extends FlutterGetItModule {
  @override
  void onClose(Injector i) {}

  @override
  void onInit(Injector i) {
    Bind.lazySingleton(
      (i) => DetailRepository(),
    );
  }

  @override
  String get moduleRouteName => '/Detail';

  @override
  List<Bind<Object>> get bindings => [
        Bind.factory(
          (i) => FormItemController(
            name: 'FormItemController',
          ),
        ),
      ];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: '/Detail',
          page: (context) => DetailPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<DetailController>(
              (i) => DetailController(),
            ),
          ],
        ),
        FlutterGetItPageRouter(
          name: '/DetailSuper',
          page: (context) => DetailSuperPage(
            controller: context.get(),
          ),
          bindings: [
            Bind.lazySingleton<DetailSuperController>(
              (i) => DetailSuperController(),
            ),
          ],
        ),
      ];
}

import '../../../flutter_getit.dart';
import '../router/params/f_get_it_router_params.dart';

extension FGetItExtensionRoute<T> on Route<T> {
  FGetItRouterParams get routeParams {
    return FGetItRouterParams(
      arguments: null,
      pathParams: {'id': 29},
      queryParams: {'query': 'value'},
    );
  }
}

import 'package:flutter/material.dart';

import '../../flutter_getit.dart';

typedef FlutterGetItRouteOutletTransictionBuilder = Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child);

class FlutterGetItRouteOutlet extends StatelessWidget {
  final String initialRoute;
  final GlobalKey<NavigatorState> navKey;
  final Widget routeNotFound;
  final FlutterGetItContextType contextType;
  final FlutterGetItRouteOutletTransictionBuilder? transitionsBuilder;

  const FlutterGetItRouteOutlet({
    super.key,
    required this.initialRoute,
    required this.navKey,
    this.routeNotFound = const PageNotFound(),
    this.contextType = FlutterGetItContextType.main,
    this.transitionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        final pages = context.get<Map<String, WidgetBuilder>>(
            tag: 'RoutesMap_${contextType.key}');
        final widget = pages[settings.name];
        if (widget != null) {
          PageRouteBuilder builder = PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                widget(context),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              if (transitionsBuilder != null) {
                return transitionsBuilder!(
                    context, animation, secondaryAnimation, child);
              }
              return child;
            },
          );
          return builder;
        }
        return MaterialPageRoute(builder: (context) => routeNotFound);
      },
    );
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}

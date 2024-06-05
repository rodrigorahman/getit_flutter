import 'package:example/application/session/model/user_model.dart';
import 'package:example/application/session/user_session.dart';
import 'package:example/src/auth/login_page.dart';
import 'package:example/src/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _home = Injector.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UserSession.updateMe(
            UserModel(
              name: 'Leo ${DateTime.now().second}',
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<UserModel?>(
              stream: UserSession.me,
              builder: (context, user) {
                return Text(user.data?.name ?? 'No User');
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await showModalBottomSheet(
                  routeSettings: const RouteSettings(name: '/Auth/Login'),
                  context: context,
                  builder: (context) => LoginPage(
                    controller: context.get(),
                  ),
                );
              },
              child: const Text(
                'Chamar bottom sheet',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Auth/LoginERROR');
              },
              child: const Text(
                'Ir a uma rota errada.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

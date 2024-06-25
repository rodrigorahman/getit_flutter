import 'package:example/application/session/model/user_model.dart';
import 'package:example/application/session/user_session.dart';
import 'package:example/src/auth/view/login/login_controller.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller;
  const LoginPage({super.key, required this.controller});

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
        title: Text(controller.name),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Auth/Register');
              },
              child: const Text('Register'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Auth/ActiveAccount');
              },
              child: const Text('Activer Account'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Auth/Register/StepTwo');
              },
              child: const Text('Register Step two'),
            ),
          ],
        ),
      ),
    );
  }
}

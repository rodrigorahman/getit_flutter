import 'package:example/application/session/model/user_model.dart';
import 'package:example/application/session/user_session.dart';
import 'package:example/src/auth/login_controller.dart';
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
        child: StreamBuilder<UserModel?>(
          stream: UserSession.me,
          builder: (context, snapshot) {
            return Text(snapshot.data?.name ?? 'No User');
          },
        ),
      ),
    );
  }
}

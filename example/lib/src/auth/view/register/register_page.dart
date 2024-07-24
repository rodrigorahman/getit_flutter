import 'package:example/src/auth/view/register/register_controller.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController controller;
  const RegisterPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed('/Auth/Register/ActiveAccount/Page');
          },
          child: const Text(
            'PushReplacementNamed - ActiveAccount - Page',
          ),
        ),
      ),
    );
  }
}

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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/Auth/Register/ActiveAccount/Page');
              },
              child: const Text(
                'PushReplacementNamed - ActiveAccount - Page',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Auth/Register/Page');
              },
              child: const Text('PushNamed - Register - Page'),
            ),
          ],
        ),
      ),
    );
  }
}

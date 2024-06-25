import 'package:example/src/auth/view/register/register_step_two/register_page_step_two_controller.dart';
import 'package:flutter/material.dart';

class RegisterPageStepTwo extends StatelessWidget {
  final RegisterStepTwoController controller;
  const RegisterPageStepTwo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterPageStepTwo'),
      ),
      body: Container(),
    );
  }
}

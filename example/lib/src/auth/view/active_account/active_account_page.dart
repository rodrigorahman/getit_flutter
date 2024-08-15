import 'package:example/src/auth/view/active_account/active_account_controller.dart';
import 'package:example/src/auth/view/active_account/validate_email_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

typedef ActiveAccountPageDependencies = ({
  ActiveAccountController controller,
  ValidateEmailController validateEmailController
});

class ActiveAccountPage
    extends FlutterGetItView<ActiveAccountPageDependencies> {
  const ActiveAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fGetIt.controller.name),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil(
                  (route) => route.settings.name == '/Home/Page',
                );
              },
              child: const Text('PopUntil - Home - Page'),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/Auth/Register/Page');
              },
              child: const Text('PushReplacementNamed - Register - Page'),
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

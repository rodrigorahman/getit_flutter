import 'dart:developer';

import 'package:example/application/session/model/user_model.dart';
import 'package:example/application/session/user_session.dart';
import 'package:example/src/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _home1 = Injector.get<HomeController>(tag: 'HomeController');
  final _home2 = Injector.get<HomeController>(tag: 'HomeController2');

  @override
  Widget build(BuildContext context) {
    log(_home1.toString());
    log(_home2.toString());
    log(context.any<HomeController>().toString());

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
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Auth/Login');
              },
              child: const Text(
                'PushNamed - Login',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Auth/Register/Page');
              },
              child: const Text(
                'PushNamed - Register - Page',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed('/Auth/Register/ActiveAccount/Page');
              },
              child: const Text(
                'PushNamed - ActiveAccount - Page',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Auth/Register/ActiveAccount');
              },
              child: const Text(
                'PushNamed - Wrong page',
              ),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Random/Page');
              },
              child: const Text(
                'PushNamed - RandomPage',
              ),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Detail/Factories/One');
              },
              child: const Text(
                'Detail One Page',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed('/Detail/Factories/One/Internal/Page');
              },
              child: const Text(
                'Detail One Internal',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed('/Detail/Factories/One/Internal/Page/Child');
              },
              child: const Text(
                'Detail One Internal Child',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/Detail/Factories/Two');
              },
              child: const Text(
                'Detail Two Page',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:example/src/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = context.get<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page $title - ${controller.title}'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Home2');
              },
              child: const Text('Go to Home 2 (Don\'t exist)'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Products');
              },
              child: const Text(
                'Go to "/Products" (It\'s a module not a route)',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Products/');
              },
              child: const Text(
                'Go to "/Products/" (It\'s a route)',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Products/29/Detail');
              },
              child: const Text(
                'Go directly to "/Products/29/Detail" (It\'s a route)',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/Products/30/Detail', arguments: 'Block');
              },
              child: const Text(
                'Go directly to "/Products/30/Detail" (It\'s a route) but with a middleware that blocks the navigation',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

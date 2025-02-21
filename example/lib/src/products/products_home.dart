import 'package:example/src/products/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ProductsHome extends StatelessWidget {
  const ProductsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.get<ProductsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      body: Center(
        child: SizedBox(
          width: 420,
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Products/Detail');
                },
                child: const Text('Push Named Detail'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/Products/');
                },
                child: const Text('Push Replacement this page'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Products/',
                    (route) => false,
                  );
                },
                child: const Text('Push NamedAndRemoveUntil this page'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed('/Products/');
                },
                child: const Text('Push popAndPushNamed this page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

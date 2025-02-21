import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String? productId;
  const ProductDetailPage({
    super.key,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail ID: $productId'),
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
                child: const Text('Push Named Detail (Again)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/Products/Detail');
                },
                child: const Text('Push Replacement this page'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Products/Detail', (route) => false);
                },
                child: const Text('Push NamedAndRemoveUntil this page'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed('/Products/Detail');
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

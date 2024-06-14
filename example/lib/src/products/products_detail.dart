import 'package:example/src/products/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductsDetail extends StatelessWidget {
  const ProductsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product ${product.name}'),
      ),
      body: const Center(
        child: FlutterLogo(),
      ),
    );
  }
}

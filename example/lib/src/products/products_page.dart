import 'package:example/src/products/model/product_model.dart';
import 'package:example/src/products/product_controller.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final ProductController ctrl;
  const ProductsPage({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: ProductModel.getFake.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('Product ${ProductModel.getFake[index].name}'),
          onTap: () => Navigator.of(context).pushNamed(
            '/Products/Page/Detail',
            arguments: ProductModel.getFake[index],
          ),
        ),
      ),
    );
  }
}

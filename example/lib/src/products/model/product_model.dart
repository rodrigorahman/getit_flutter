class ProductModel {
  final String name;

  ProductModel({required this.name});

  static List<ProductModel> get getFake => [
        ProductModel(name: 'Camiseta'),
        ProductModel(name: 'Short'),
        ProductModel(name: 'Boné'),
        ProductModel(name: 'Calça'),
        ProductModel(name: 'Armario'),
      ];
}

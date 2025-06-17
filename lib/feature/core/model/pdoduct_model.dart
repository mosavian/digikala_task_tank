class ProductModel {
  final int id;
  final String title;
  final String imageUrl;
  final int price;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title_fa'] ?? 'بدون عنوان',
      imageUrl: (json['images']?['main']?['url'] as List?)?.first ?? '',
      price: json['default_variant']?['price']?['selling_price'] ?? 0,
    );
  }
}

class ProductDetailModel {
  final int id;
  final String title;
  final String imageUrl;
  final int price;
  final String seller;
  final String warranty;
  final String color;
  final String colorHex;
  final List<String> shortSpecifications;

  ProductDetailModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.seller,
    required this.warranty,
    required this.color,
    required this.colorHex,
    required this.shortSpecifications,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    // ✅ Print raw fields for debugging
    print('🧪 title_fa: ${json['title_fa']}');
    print('🧪 imageUrl: ${(json['images']?['main']?['url'] as List?)?.first}');
    print('🧪 price: ${json['price']?['selling_price']}');
    print('📦 full price object: ${json['price']}');
    // ✅ Short specs (just first 2 groups x 2 attributes)
    final List<String> specs = [];
    final specList = json['specifications'] as List?;
    if (specList != null && specList.isNotEmpty) {
      for (final group in specList.take(2)) {
        final attributes = group['attributes'] as List?;
        if (attributes != null) {
          for (final attr in attributes.take(2)) {
            final title = attr['title'] ?? '';
            final values = (attr['values'] as List?)?.join(', ') ?? '';
            specs.add('$title: $values');
          }
        }
      }
    }

    return ProductDetailModel(
      id: json['id'] ?? 0,
      title: json['title_fa'] ?? '',
      imageUrl: (json['images']?['main']?['url'] as List?)?.first ?? '',
      price: json['default_variant']?['price']?['selling_price'] ?? 0,
      seller: json['seller']?['title'] ?? 'نامشخص',
      warranty: json['warranty']?['title_fa'] ?? 'بدون گارانتی',
      color: json['color']?['title'] ?? 'نامشخص',
      colorHex: json['color']?['hex_code'] ?? '#000000',
      shortSpecifications: specs,
    );
  }
}

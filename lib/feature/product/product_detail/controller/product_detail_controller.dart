import 'package:digikala_app/feature/core/model/product_detail_model.dart';
import 'package:digikala_app/feature/product/product_detail/repository/product_detail_repository.dart';
import 'package:flutter/material.dart';

class ProductDetailController extends ChangeNotifier {
  final ProductDetailRepository repository;

  ProductDetailController(this.repository);

  bool isLoading = false;
  bool hasError = false;
  ProductDetailModel? product;

  // Fetch product detail by ID
  Future<void> loadProduct(int productId) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    print('📡 Loading product with ID: $productId');

    try {
      final result = await repository.fetchProductDetail(productId);
      print('✅ Product fetched: ${result.title}');
      product = result;
    } catch (e) {
      hasError = true;
      print('❌ Error loading product: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}

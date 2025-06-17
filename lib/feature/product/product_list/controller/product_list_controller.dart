import 'package:digikala_app/feature/core/model/pdoduct_model.dart';
import 'package:digikala_app/feature/product/product_list/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductListController extends ChangeNotifier {
  final ProductRepository repository;

  ProductListController({required this.repository});

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  String query = 'گوشی'; // default query
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _isEndReached = false;
  bool get isEndReached => _isEndReached;

  int _page = 1;

  Future<void> fetchProducts() async {
    if (_isLoading || _isEndReached) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      print('📥 در حال دریافت صفحه $_page از API...');
      final newProducts = await repository.fetchProducts(
        page: _page,
        query: query,
      );
      print('✅ ${newProducts.length} محصول دریافت شد.');

      if (newProducts.isEmpty) {
        _isEndReached = true;
      } else {
        _products.addAll(newProducts);
        _page++;
      }
    } catch (e) {
      _hasError = true;
      print('❌ خطا در دریافت یا پردازش دیتا: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateQuery(String newQuery) {
    _products = [];
    _page = 1;
    _isEndReached = false;
    _hasError = false;
    query = newQuery;
    fetchProducts();
  }

  void reset() {
    _products = [];
    _page = 1;
    _isEndReached = false;
    notifyListeners();
    fetchProducts();
  }
}

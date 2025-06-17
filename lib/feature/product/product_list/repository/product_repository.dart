import 'dart:convert';

import 'package:digikala_app/feature/core/model/pdoduct_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<List<ProductModel>> fetchProducts({
    required int page,
    required String query,
  }) async {
    final url = Uri.parse(
      'https://api.digikala.com/v1/categories/mobile-phone/search/?q=$query&page=$page',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List productsJson = data['data']['products'];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception(
          "خطا در دریافت اطلاعات از سرور: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("❌ خطا در ProductRepository: $e");
      throw Exception("خطا در اتصال یا پردازش اطلاعات");
    }
  }
}

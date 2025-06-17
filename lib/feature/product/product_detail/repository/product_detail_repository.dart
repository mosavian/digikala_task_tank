import 'dart:convert';
import 'package:digikala_app/feature/core/model/product_detail_model.dart';
import 'package:http/http.dart' as http;

class ProductDetailRepository {
  // Fetch product detail data from Digikala API
  Future<ProductDetailModel> fetchProductDetail(int productId) async {
    print('📥 Sending request to Digikala API for ID $productId');
    try {
      final url = Uri.parse('https://api.digikala.com/v2/product/$productId/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data =
            json['data']['product']; // ✅ Only pass 'data' part to the model
        return ProductDetailModel.fromJson(data);
      } else {
        throw Exception(
          '❌ Failed to load product detail. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error in ProductDetailRepository: $e');
      throw Exception('Network or parsing error');
    }
  }
}

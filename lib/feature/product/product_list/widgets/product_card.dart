import 'package:digikala_app/feature/core/model/pdoduct_model.dart';
import 'package:digikala_app/feature/product/product_detail/controller/product_detail_controller.dart';
import 'package:digikala_app/feature/product/product_detail/repository/product_detail_repository.dart';
import 'package:digikala_app/feature/product/product_detail/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###', 'fa');
    return '${formatter.format(price)} تومان';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => ProductDetailController(ProductDetailRepository()),
              child: ProductDetailScreen(productId: product.id),
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      formatPrice(product.price),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

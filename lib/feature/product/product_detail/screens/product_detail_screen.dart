import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/product_detail_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductDetailController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.product == null && !controller.isLoading) {
        controller.loadProduct(productId);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(title: const Text('جزئیات محصول'), centerTitle: true),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.hasError
          ? const Center(child: Text('خطا در دریافت اطلاعات'))
          : controller.product == null
          ? const Center(child: Text('محصولی یافت نشد'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            controller.product!.imageUrl,
                            height: 220,
                            width: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, size: 60),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.product!.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${controller.product!.price} تومان',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.local_shipping,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'ارسال سریع دیجی‌کالا',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoItem('فروشنده', controller.product!.seller),
                            _infoItem('گارانتی', controller.product!.warranty),
                            _colorItem(
                              'رنگ',
                              controller.product!.color,
                              controller.product!.colorHex,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'ویژگی‌های برجسته:',

                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 8),
                        ...controller.product!.shortSpecifications.map(
                          (spec) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '• $spec',
                              style: const TextStyle(fontSize: 13),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: controller.product != null
          ? Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  // todo: add to cart
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'افزودن به سبد خرید',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : null,
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _colorItem(String title, String name, String hex) {
    final color = Color(int.parse(hex.replaceFirst('#', '0xff')));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            CircleAvatar(backgroundColor: color, radius: 6),
            const SizedBox(width: 6),
            Text(
              name,
              style: const TextStyle(fontSize: 13),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/product_detail_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductDetailController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.product == null && !controller.isLoading) {
        controller.loadProduct(productId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('جزئیات محصول', textAlign: TextAlign.center),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.hasError
          ? const Center(child: Text('خطا در بارگذاری اطلاعات'))
          : controller.product == null
          ? const Center(child: Text('داده‌ای موجود نیست'))
          : _buildContent(context, controller),
      bottomNavigationBar: controller.product != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('افزودن به سبد خرید'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductDetailController controller,
  ) {
    final p = controller.product!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Image.network(
            p.imageUrl,
            height: 300,
            fit: BoxFit.fitHeight,
            errorBuilder: (_, __, ___) => const SizedBox(
              height: 300,
              child: Center(child: Icon(Icons.image, size: 50)),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),

                // Price
                Text(
                  '${p.price} تومان',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),

                // Details row
                Row(
                  children: [
                    _detailTag('فروشنده', p.seller),
                    _detailTag('گارانتی', p.warranty),
                    _colorIndicator(p.color, p.colorHex),
                  ],
                ),
                const SizedBox(height: 16),

                // Specifications header
                const Text(
                  'مشخصات کلی:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                // Specs list
                ...p.shortSpecifications.map(
                  (s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• $s', textDirection: TextDirection.rtl),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailTag(String title, String value) => Expanded(
    child: Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
        ),
        Flexible(child: Text(value, textDirection: TextDirection.rtl)),
      ],
    ),
  );

  Widget _colorIndicator(String name, String hex) => Expanded(
    child: Row(
      children: [
        const Text(
          'رنگ: ',
          style: TextStyle(fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
        ),
        CircleAvatar(
          backgroundColor: Color(int.parse(hex.replaceFirst('#', '0xff'))),
          radius: 8,
        ),
        const SizedBox(width: 8),
        Flexible(child: Text(name, textDirection: TextDirection.rtl)),
      ],
    ),
  );
}

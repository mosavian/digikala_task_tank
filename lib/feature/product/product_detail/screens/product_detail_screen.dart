import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/product_detail_controller.dart';
import 'dart:ui' as ui;

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  ProductDetailScreen({super.key, required this.productId});
  String formatPrice(int price) {
    final formatter = NumberFormat('#,###', 'fa');
    return '${formatter.format(price)}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductDetailController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.product == null && !controller.isLoading) {
        controller.loadProduct(productId);
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(title: Text('جزئیات محصول'), centerTitle: true),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.hasError
          ? Center(child: Text('خطا در دریافت اطلاعات'))
          : controller.product == null
          ? Center(child: Text('محصولی یافت نشد'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                Icon(Icons.image, size: 60),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          controller.product!.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: ui.TextDirection.rtl,
                        ),
                        SizedBox(height: 12),
                        Text(
                          '${formatPrice(controller.product!.price)} ریال',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textDirection: ui.TextDirection.rtl,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 18,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'ارسال سریع دیجی‌کالا',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                              ),
                              textDirection: ui.TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ویژگی‌های برجسته:',

                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: ui.TextDirection.rtl,
                        ),
                        SizedBox(height: 8),
                        ...controller.product!.shortSpecifications.map(
                          (spec) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '• $spec',
                              style: TextStyle(fontSize: 13),
                              textDirection: ui.TextDirection.rtl,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: controller.product != null
          ? Container(
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  // todo: add to cart
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'افزودن به سبد خرید',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textDirection: ui.TextDirection.rtl,
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
          textDirection: ui.TextDirection.rtl,
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
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textDirection: ui.TextDirection.rtl,
        ),
        SizedBox(height: 4),
        Row(
          children: [
            CircleAvatar(backgroundColor: color, radius: 6),
            SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(fontSize: 13),
              textDirection: ui.TextDirection.rtl,
            ),
          ],
        ),
      ],
    );
  }
}

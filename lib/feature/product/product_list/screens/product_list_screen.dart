import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/product_list_controller.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Fetch initial product list after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductListController>(
        context,
        listen: false,
      ).fetchProducts();
    });
  }

  void _onScroll() {
    final controller = Provider.of<ProductListController>(
      context,
      listen: false,
    );
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !controller.isLoading &&
        !controller.isEndReached) {
      controller.fetchProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: Consumer<ProductListController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              // Search field
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  textAlign: TextAlign.right,

                  decoration: InputDecoration(
                    hintText: '...جستجو',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  textDirection: TextDirection.rtl,
                  onSubmitted: (value) {
                    controller.updateQuery(value);
                  },
                ),
              ),

              // Product list or status
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (controller.isLoading && controller.products.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (controller.hasError) {
                      return Center(child: Text('Error loading products.'));
                    }

                    if (controller.products.isEmpty) {
                      return Center(child: Text('No products found.'));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: controller.products.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.products.length) {
                          final product = controller.products[index];
                          return ProductCard(product: product);
                        } else {
                          return controller.isLoading
                              ? Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

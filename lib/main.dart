import 'package:digikala_app/feature/product/product_list/controller/product_list_controller.dart';
import 'package:digikala_app/feature/product/product_list/repository/product_repository.dart';
import 'package:digikala_app/feature/product/product_list/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductListController(repository: ProductRepository()),
        ),
      ],
      child: Application(),
    ),
  );
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SM'),

      home: ProductListScreen(),
    );
  }
}

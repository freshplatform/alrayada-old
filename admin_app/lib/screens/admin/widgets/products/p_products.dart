import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'You can add product either by go to category or sub-category and view the products page and add new product.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

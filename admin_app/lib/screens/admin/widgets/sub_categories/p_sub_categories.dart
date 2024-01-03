import 'package:flutter/material.dart';

class SubCategoriesPage extends StatelessWidget {
  const SubCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'To add sub-categories, go to any category in the categories list, and that category should not have any product! that is important, otherwise unexpected errors could happen, delete all the products for that category if it have, then add the sub-categories',
        textAlign: TextAlign.center,
      ),
    );
  }
}

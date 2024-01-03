import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';

import '../../../../providers/p_product_category.dart';

class DeleteCategoryDialog extends ConsumerStatefulWidget {
  const DeleteCategoryDialog({
    required this.isSubCategory, required this.category, super.key,
    this.subCategoryIndex,
  });

  final bool isSubCategory;
  final ProductCategory category;
  final int? subCategoryIndex;

  @override
  ConsumerState<DeleteCategoryDialog> createState() =>
      _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends ConsumerState<DeleteCategoryDialog> {
  var _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    final error = await _deleteParentOrSubCategory();
    if (error == null) {
      Future.microtask(() => Navigator.of(context).pop());
      return;
    }
    Future.microtask(
      () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      )),
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> _deleteParentOrSubCategory() async {
    if (widget.isSubCategory) {
      return await ref
          .read(CategoryItemNotifier.provider(widget.category).notifier)
          .deleteSubCategory(widget.subCategoryIndex!);
    }
    return await ref
        .read(CategoriesNotififer.provider.notifier)
        .deleteParentCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning!'),
      content: Text(
        widget.isSubCategory
            ? 'All of the products of this sub category will also deleted!'
            : 'All sub-categories of this category and all the products will also be deleted! the previous orders that use the deleted products will be hidden!!',
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: !_isLoading ? _submit : null,
          child: !_isLoading
              ? const Text('Delete')
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ],
    );
  }
}

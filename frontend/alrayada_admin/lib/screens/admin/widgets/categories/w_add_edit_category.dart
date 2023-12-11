import 'dart:io';

import 'package:alrayada_admin/providers/p_product_category.dart';
import 'package:alrayada_admin/utils/validators/global.dart';
import 'package:alrayada_admin/widgets/w_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';

class AddEditCategoryDialog extends ConsumerStatefulWidget {
  const AddEditCategoryDialog({
    super.key,
    required this.categoryToEdit,
    this.subCategoryParentId,
    this.parentCategoryOfTheSubCategory,
  });
  final ProductCategory? categoryToEdit;
  final String? subCategoryParentId;
  final ProductCategory? parentCategoryOfTheSubCategory;

  @override
  ConsumerState<AddEditCategoryDialog> createState() =>
      _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends ConsumerState<AddEditCategoryDialog> {
  var _isLoading = false;

  bool get isEdit => widget.categoryToEdit != null;
  ProductCategory get _categoryToEdit => widget.categoryToEdit!;

  var _categoryRequest = const ProductCategoryRequest();
  final _formKey = GlobalKey<FormState>();
  File? _file;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shortDescriptionController = TextEditingController();

  Future<void> _submit() async {
    final validate = _formKey.currentState?.validate() ?? false;
    if (!validate) return;
    _formKey.currentState!.save();
    if (!isEdit) {
      if (_file == null || !(await _file!.exists())) {
        return;
      }
    }
    setState(() {
      _isLoading = true;
    });
    _categoryRequest = _categoryRequest.copyWith(
      parent: widget.categoryToEdit?.parent ?? widget.subCategoryParentId,
    );

    // final error = (!isEdit
    //     ? await
    //     : await ref
    //         .read(CategoryItemNotifier.provider(_categoryToEdit).notifier)
    //         .updateProductCategory(
    //           newFilePath: _file?.path,
    //           productCategoryRequest: _categoryRequest,
    //         ));
    final error = await _addEditParentOrSubCategory();
    if (error == null) {
      Future.microtask(() => Navigator.of(context).pop(true));
      return;
    }
    Future.microtask(
      () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      )),
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> _addEditParentOrSubCategory() async {
    if (isEdit) {
      return await ref
          .read(CategoryItemNotifier.provider(_categoryToEdit).notifier)
          .updateSubCategory(
            newFilePath: _file?.path,
            productCategoryRequest: _categoryRequest,
          );
    }
    // Add parent category who have no parent
    if (_categoryRequest.parent == null) {
      return ref.read(CategoriesNotififer.provider.notifier).addCategory(
            filePath: _file?.path,
            productCategoryRequest: _categoryRequest,
          );
    }
    // Add sub category
    if (widget.parentCategoryOfTheSubCategory == null) {
      throw 'Parent category should not be empty when add or edit a sub category';
    }
    return ref
        .read(
          CategoryItemNotifier.provider(
            widget.parentCategoryOfTheSubCategory!,
          ).notifier,
        )
        .addSubCategory(
          productCategoryRequest: _categoryRequest,
          filePath: _file?.path,
          ref: ref,
        );
  }

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _nameController.text = _categoryToEdit.name;
      _descriptionController.text = _categoryToEdit.description;
      _shortDescriptionController.text = _categoryToEdit.shortDescription;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _shortDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: !_isLoading ? _submit : null,
          child: !_isLoading
              ? Text(isEdit ? 'Update' : 'Add')
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ],
      title: Text(isEdit ? 'Edit ${_categoryToEdit.name}' : 'Add category'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    GlobalValidators.validateIsNotEmpty(value),
                onSaved: (newValue) => _categoryRequest =
                    _categoryRequest.copyWith(name: newValue ?? ''),
                controller: _nameController,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // validator: (value) =>
                //     GlobalValidators.validateIsNotEmpty(value),
                controller: _descriptionController,
                onSaved: (newValue) => _categoryRequest =
                    _categoryRequest.copyWith(description: newValue ?? ''),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Short description'),
                textInputAction: TextInputAction.next,
                controller: _shortDescriptionController,
                onSaved: (newValue) => _categoryRequest =
                    _categoryRequest.copyWith(shortDescription: newValue ?? ''),
              ),
              const SizedBox(height: 8),
              FilePickerWidget(
                onPickFile: (file) {
                  _file = file;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

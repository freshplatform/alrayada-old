import 'dart:io';

import 'package:flutter/material.dart';

import 'package:alrayada_admin/providers/p_product.dart';
import 'package:alrayada_admin/utils/validators/global.dart';
import 'package:alrayada_admin/widgets/w_file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '../../utils/validators/product.dart';

class AddEditProduct extends ConsumerStatefulWidget {
  const AddEditProduct({super.key, required this.category, this.product});

  final ProductCategory category;
  final Product? product;

  @override
  ConsumerState<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends ConsumerState<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  late ProductRequest _productRequest;
  File? _file;

  bool get isEdit => widget.product != null;
  Product get productToEdit => widget.product!;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _originalPrice = TextEditingController();
  final _discountPercentage = TextEditingController(text: '0.0');

  @override
  void initState() {
    super.initState();
    _productRequest = ProductRequest(categories: [widget.category.id]);
    if (isEdit) {
      _nameController.text = productToEdit.name;
      _descriptionController.text = productToEdit.description;
      _shortDescriptionController.text = productToEdit.shortDescription;
      _originalPrice.text = productToEdit.originalPrice.toString();
      _discountPercentage.text = productToEdit.discountPercentage.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _shortDescriptionController.dispose();
    _originalPrice.dispose();
    _discountPercentage.dispose();
    super.dispose();
  }

  void setLoading(bool value) => setState(() {
        _isLoading = value;
      });

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    if (_file != null) {
      if (!(await _file!.exists())) return;
    }
    _formKey.currentState!.save();
    setLoading(true);
    final error = (isEdit
        ? await ref
            .read(ProductItemNotifier.provider(productToEdit).notifier)
            .updateProduct(
              newFilePath: _file?.path,
              productRequest: _productRequest,
              productId: productToEdit.id,
            )
        : await ref.read(ProductsNotifier.provider.notifier).addProduct(
              filePath: _file?.path,
              productRequest: _productRequest,
            ));
    if (error == null) {
      Future.microtask(() => Navigator.of(context).pop());
      return;
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit ${productToEdit.name}' : 'Add product'),
      content: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    GlobalValidators.validateIsNotEmpty(value),
                onSaved: (newValue) => _productRequest =
                    _productRequest.copyWith(name: newValue ?? ''),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // validator: (value) => GlobalValidators.validateIsNotEmpty(value),
                onSaved: (newValue) => _productRequest =
                    _productRequest.copyWith(description: newValue ?? ''),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _shortDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Short description'),
                textInputAction: TextInputAction.next,
                // validator: (value) => GlobalValidators.validateIsNotEmpty(value),
                onSaved: (newValue) => _productRequest =
                    _productRequest.copyWith(shortDescription: newValue ?? ''),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _originalPrice,
                decoration: const InputDecoration(
                  labelText: 'Original price',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    ProductValidators.validateOriginalPrice(value),
                onSaved: (newValue) =>
                    _productRequest = _productRequest.copyWith(
                  originalPrice: double.parse(newValue ?? '-1.0'),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _discountPercentage,
                decoration: const InputDecoration(
                  labelText: 'Discount percentage',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    ProductValidators.validateDiscountPercentage(value),
                onSaved: (newValue) => _productRequest =
                    _productRequest.copyWith(
                        discountPercentage: double.parse(newValue ?? '-1.0')),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              FilePickerWidget(onPickFile: (file) => _file = file),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}

class ProductValidators {
  ProductValidators.privateConstructor();

  static String? validateOriginalPrice(String? value) {
    final field = value?.trim() ?? '';
    final doubleValue = double.tryParse(field);
    if (doubleValue == null) {
      return 'Please enter valid number';
    }
    if (doubleValue <= 0) {
      return 'Price shoult be greater than 0';
    }
    return null;
  }

  static String? validateDiscountPercentage(String? value) {
    final field = value?.trim() ?? '';
    final doubleValue = double.tryParse(field);
    if (doubleValue == null) {
      return 'Please enter valid number';
    }
    if (doubleValue < 0 || doubleValue > 100) {
      return 'Discount should between 0 and 100';
    }
    return null;
  }
}

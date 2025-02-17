import 'package:flutter/material.dart';

import '../../../../constants/shop/product/product_option_type.dart';

class ProductOptionModel {
  TextEditingController nameController;
  TextEditingController quantityController;
  ProductOptionType type;

  ProductOptionModel({

    required this.nameController,
    required this.quantityController,
    required this.type
  });
}
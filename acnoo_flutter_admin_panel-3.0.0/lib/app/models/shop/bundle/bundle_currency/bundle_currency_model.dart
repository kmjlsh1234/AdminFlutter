import 'package:flutter/material.dart';

import '../../../../constants/shop/item/currency_type.dart';

class BundleCurrencyModel{
  CurrencyType currencyType;
  TextEditingController countController;

  BundleCurrencyModel({
    required this.currencyType,
    required this.countController
  });
}
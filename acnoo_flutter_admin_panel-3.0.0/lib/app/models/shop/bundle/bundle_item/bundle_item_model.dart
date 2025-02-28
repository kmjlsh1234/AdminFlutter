import 'package:flutter/cupertino.dart';

import '../../item/item.dart';

class BundleItemModel {
  Item? item;
  final TextEditingController nameController;
  final TextEditingController countController;

  BundleItemModel({
    required this.item,
    required this.nameController,
    required this.countController
  });
}
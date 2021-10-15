import 'package:flutter/foundation.dart';

class ProductModel {
  String? productName;
  double? pricePerItemPurchased;
  int? quantity;
  String? productID;

  ProductModel({
    this.productName,
    this.pricePerItemPurchased,
    this.quantity,
    this.productID,
  });
}

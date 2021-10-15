import 'package:dhismoappadmin/add_new_project/add_new_project_state.dart';
import 'package:dhismoappadmin/models/product_model.dart';
import 'package:dhismoappadmin/models/total_products_price_model.dart';
import 'package:dhismoappadmin/service/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListProvider = ChangeNotifierProvider<ProductListState>((ref) {
  final currentProjectName =
      ref.watch(addNewProjectProvider).currentProjectName;

  return ProductListState(projectID: currentProjectName);
});

//--
class ProductListState extends ChangeNotifier {
  ProductListState({this.projectID});

  String? projectID;
  List<ProductModel> _productList = [];

  List<ProductModel> get productList => _productList;

  addData(
      {required String? productName,
      required double? pricePerItemPurchased,
      required int? quantity}) {
    Service(projectID: projectID).addData(
        productName: productName,
        pricePerItemPurchased: pricePerItemPurchased,
        quantity: quantity);
  }

  getListOfProducts(List<ProductModel> products) {
    _productList = products;
  }

  deleteProduct(
      {required String prodID,
      required double pricePurchase,
      required double priceSold,
      required int quantityLeft}) {
    Service().deleteProduct(
        prodID: prodID,
        pricePurchase: pricePurchase,
        priceSold: priceSold,
        quantityLeft: quantityLeft);
  }

  Stream<List<ProductModel>> getProductStream(String projectID) {
    return Service()
        .projects
        .doc(projectID)
        .collection('products')
        .snapshots()
        .map(Service().getProductSnapshot);
  }

  Stream<TotalProductsPriceModel> totalSoldStream(String projectID) {
    return Service()
        .projects
        .doc(projectID)
        .collection('totalOfProducts')
        .doc('totalData')
        .snapshots()
        .map(Service().getTotalSold);
  }
}

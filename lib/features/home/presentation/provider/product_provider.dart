import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totalx_testpproject/features/home/data/i_productfacade.dart';
import 'package:totalx_testpproject/features/home/data/model/product_models.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider(this.iProductfacade);

  // Assign into List
  List<ProductModels> productList = [];

  // Controllers to manage products
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productStockController = TextEditingController();

  final IProductfacade iProductfacade;

//upload Product
  Future<void> uploadProduct({
    required void Function() onFailure,
    required void Function() onSuccess,
    required String userId,
  }) async {
    final result = await iProductfacade.uploadProduct(
        prodectModels: ProductModels(
            userId: userId,
            productName: productNameController.text,
            price: num.parse(productPriceController.text) as int,
            stock: int.parse(productStockController.text),
            createdAt: Timestamp.now()),
        userId: userId);

    result.fold(
      (errs) {
        onFailure.call();
      },
      (success) {
        onSuccess.call();
      },
    );
  }

//fetch Products
  Future<void> fetchProducts({
    required String userId,
  }) async {
    final result = await iProductfacade.fetchProducts(userId: userId);

    result.fold(
      (l) {
        log(l.errormsg);
      },
      (r) {
        log(r.length.toString());
        productList.clear();
        productList.addAll(r);
        notifyListeners();
      },
    );
  }

//clear Datas
  void clearProductList() {
    // IProductfacade.clearData();
    productList = [];
    notifyListeners();
  }
}

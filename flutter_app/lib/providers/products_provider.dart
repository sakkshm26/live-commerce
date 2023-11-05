import 'package:flutter/material.dart';
import 'package:touchbase/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void setInitialProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(String id, Product updatedProduct) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
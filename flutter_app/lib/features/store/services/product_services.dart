import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import "package:http/http.dart" as http;
import 'package:touchbase/constants/global_variables.dart';
import 'package:touchbase/constants/util_functions.dart';
import 'package:touchbase/models/product.dart';
import 'package:touchbase/providers/products_provider.dart';
import 'package:touchbase/providers/user_provider.dart';

class ProductServices {
  Future<List<dynamic>?> getProducts({required BuildContext context}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

      http.Response res = await http.get(
        Uri.parse('${GlobalVariables.uri}/product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${userProvider.user!.token}"
        },
      );

      var jsonData = jsonDecode(res.body) as List<dynamic>;

      List<Product> products = jsonData
          .map((item) => Product(
                id: item['id'],
                title: item['title'],
                description: item['description'],
                price: item['price'],
                imageUrl: item['image_url'],
                createdAt: item['created_at'],
                productUrl: item['product_url'],
              ))
          .toList();

      productsProvider.setInitialProducts(products);

      return products;
    } catch (err) {
      debugPrint("$err");
      showCustomSnackBar(context: context, message: "Something went wrong when getting products");
      return null;
    }
  }

  Future<ServiceReturnType> getProduct({required String id, required BuildContext context}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.get(
        Uri.parse('${GlobalVariables.uri}/product/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${userProvider.user!.token}"
        },
      );

      var jsonData = jsonDecode(res.body);

      return ServiceReturnType(data: jsonData);
    } catch (err) {
      debugPrint("$err");
      showCustomSnackBar(context: context, message: "Something went wrong when getting products");
      return ServiceReturnType(errorMessage: "Something went wrong when getting a product");
    }
  }

  Future<ServiceReturnType> addProduct({required BuildContext context, required dynamic data}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final productProvider = Provider.of<ProductsProvider>(context, listen: false);

      var request = http.MultipartRequest("POST", Uri.parse('${GlobalVariables.uri}/product'));

      request.fields["title"] = data["title"];
      request.fields["description"] = data["description"];
      request.fields["price"] = data["price"].toString();
      request.fields["product_url"] = data["product_url"];
      request.headers["Authorization"] = "Bearer ${userProvider.user!.token}";

      var pic = await http.MultipartFile.fromPath("image", data["image"].path);
      request.files.add(pic);

      var response = await request.send();

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      var jsonData = jsonDecode(responseString);

      productProvider.addProduct(
        Product(
          id: jsonData["id"],
          title: jsonData["title"],
          description: jsonData["description"],
          price: jsonData["price"],
          imageUrl: jsonData["image_url"],
          createdAt: jsonData["created_at"],
          productUrl: jsonData["product_url"],
        ),
      );

      return ServiceReturnType(data: true);
    } catch (err) {
      debugPrint("$err");
      return ServiceReturnType(errorMessage: "Something went wrong when adding a product");
    }
  }

  Future<ServiceReturnType> updateProduct({required BuildContext context, required dynamic data}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final productProvider = Provider.of<ProductsProvider>(context, listen: false);

      var request = http.MultipartRequest("PUT", Uri.parse('${GlobalVariables.uri}/product/${data["id"]}'));

      request.fields["title"] = data["title"];
      request.fields["description"] = data["description"];
      request.fields["price"] = data["price"].toString();
      request.fields["product_url"] = data["product_url"];
      request.headers["Authorization"] = "Bearer ${userProvider.user!.token}";

      if (data["image"] != null) {
        var pic = await http.MultipartFile.fromPath("image", data["image"].path);
        request.files.add(pic);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        var jsonData = jsonDecode(responseString);
        // debugPrint("json res ---------> $jsonData");

        productProvider.updateProduct(
          data["id"],
          Product(
            id: jsonData["id"],
            title: jsonData["title"],
            description: jsonData["description"],
            price: jsonData["price"],
            imageUrl: jsonData["image_url"],
            createdAt: jsonData["created_at"],
            productUrl: jsonData["product_url"],
          ),
        );

        return ServiceReturnType(data: jsonData);
      } else {
        return ServiceReturnType(errorMessage: "Something went wrong when adding a product");
      }
    } catch (err) {
      debugPrint("$err");
      return ServiceReturnType(errorMessage: "Something went wrong when adding a product");
    }
  }

  Future<ServiceReturnType> deleteProduct({required String id, required BuildContext context}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final productProvider = Provider.of<ProductsProvider>(context, listen: false);

      http.Response res = await http.delete(Uri.parse('${GlobalVariables.uri}/product/$id'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${userProvider.user!.token}"
      });

      if (res.statusCode == 200) {
        productProvider.deleteProduct(id);
      }

      return ServiceReturnType(data: true);
    } catch (err) {
      debugPrint("$err");
      return ServiceReturnType(errorMessage: "Something went wrong when adding a product");
    }
  }
}

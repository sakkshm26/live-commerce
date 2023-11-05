import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/store/screens/livestream.dart';
import 'package:touchbase/features/store/services/product_services.dart';
import 'package:touchbase/features/store/widgets/select_product_card.dart';
import 'package:touchbase/providers/products_provider.dart';

class SelectLivestreamProductScreen extends StatefulWidget {
  static const String routeName = '/select-livestream-products';
  final String title;
  final File? image;
  const SelectLivestreamProductScreen({super.key, required this.title, this.image});

  @override
  State<SelectLivestreamProductScreen> createState() => _SelectLivestreamProductScreenState();
}

class _SelectLivestreamProductScreenState extends State<SelectLivestreamProductScreen> {
  late ProductsProvider _productsProvider;
  var isLoading = true;
  List? products = [];
  List<String> selectedProductIds = [];

  Future<void> getProducts() async {
    final products = await ProductServices().getProducts(context: context);

    if (products == null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Something went wrong when getting products");
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleProductClick(String id, String type) {
    if (type == "add") {
      selectedProductIds.add(id);
    } else {
      selectedProductIds.remove(id);
    }
  }

  @override
  void initState() {
    super.initState();

    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    _productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Products"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            LivestreamScreen.routeName,
            arguments: {"title": widget.title, "image": widget.image, "selected_product_ids": selectedProductIds},
          );
        },
        backgroundColor: Colors.black54,
        child: const Icon(Icons.arrow_right_alt),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black,),
            )
          : _productsProvider.products.isEmpty
              ? const Text("No products added")
              : RefreshIndicator(
                  onRefresh: getProducts,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: _productsProvider.products.length,
                    itemBuilder: (context, index) {
                      return SelectProductCard(
                        id: _productsProvider.products[index].id,
                        imageUrl: _productsProvider.products[index].imageUrl,
                        title: _productsProvider.products[index].title,
                        description: _productsProvider.products[index].description,
                        price: _productsProvider.products[index].price,
                        callback: handleProductClick,
                      );
                    },
                  ),
                ),
    );
  }
}

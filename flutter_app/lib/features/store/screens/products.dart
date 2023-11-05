import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/store/screens/add_or_edit_product.dart';
import 'package:touchbase/features/store/services/product_services.dart';
import 'package:touchbase/features/store/widgets/product_card.dart';
import 'package:touchbase/providers/products_provider.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '/products';
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ProductsProvider _productsProvider;
  var isLoading = true;
  List? products = [];

  Future<void> getProducts() async {
    final products = await ProductServices().getProducts(context: context);

    if (products == null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Something went wrong when getting products");
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
        title: const Text("Products"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddOrEditProductScreen.routeName, arguments: {"type": "ADD"});
        },
        backgroundColor: Colors.black54,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      return ProductCard(
                        id: _productsProvider.products[index].id,
                        imageUrl: _productsProvider.products[index].imageUrl,
                        title: _productsProvider.products[index].title,
                        description: _productsProvider.products[index].description,
                        price: _productsProvider.products[index].price,
                      );
                    },
                  ),
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/store/screens/add_or_edit_product.dart';
import 'package:touchbase/features/store/screens/products.dart';
import 'package:touchbase/features/store/services/product_services.dart';
import 'package:touchbase/models/product.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:touchbase/constants/util_functions.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '/product';
  final String id;
  const ProductScreen({super.key, required this.id});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  Product? product;

  Future<void> getProduct() async {
    final res = await ProductServices().getProduct(id: widget.id, context: context);

    if (res.errorMessage != null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: res.errorMessage!);
      }
    } else {
      product = Product.fromJson(res.data);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black,),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: FadeInImage.memoryNetwork(
                        image: product!.imageUrl,
                        height: 380,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 260,
                            decoration: const BoxDecoration(color: Color.fromARGB(255, 238, 238, 238)),
                            child: const Center(
                              child: Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product!.title,
                                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.visible,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                product!.description,
                                style: const TextStyle(color: Colors.grey, fontSize: 17),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "₹${UtilFunctions().formatNumberWithCommas(product!.price)}",
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AddOrEditProductScreen.routeName, arguments: {
                                  "type": "EDIT",
                                  "id": product!.id,
                                  "title": product!.title,
                                  "description": product!.description,
                                  "price": product!.price,
                                  "imageUrl": product!.imageUrl,
                                  "productUrl": product!.productUrl,
                                }).then(
                                  (value) {
                                    if (value != null) {
                                      final data = value as Map<String, dynamic>;
                                      setState(
                                        () {
                                          product = Product(
                                            id: widget.id,
                                            title: data["title"],
                                            description: data["description"],
                                            price: data["price"],
                                            imageUrl: data["image_url"],
                                            createdAt: product!.createdAt,
                                            productUrl: data["product_url"],
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      bool isDeleting = false;
                                      return StatefulBuilder(
                                        builder: (context, setState) => Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                const SizedBox(height: 10),
                                                const Text('Delete this product?'),
                                                const SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('No'),
                                                    ),
                                                    isDeleting
                                                        ? const SizedBox(
                                                            height: 18, width: 18, child: CircularProgressIndicator(color: Colors.black,))
                                                        : TextButton(
                                                            onPressed: () async {
                                                              setState(() {
                                                                isDeleting = true;
                                                              });
                                                              ServiceReturnType res = await ProductServices()
                                                                  .deleteProduct(id: widget.id, context: context);
                                                              if (res.data && context.mounted) {
                                                                Navigator.popUntil(
                                                                    context,
                                                                    (route) =>
                                                                        route.settings.name ==
                                                                        ProductsScreen.routeName);
                                                              } else {
                                                                if (res.errorMessage != null) {
                                                                  showCustomSnackBar(
                                                                      context: context, message: res.errorMessage!);
                                                                }
                                                              }
                                                            },
                                                            child: const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                color: Color.fromARGB(255, 205, 20, 7),
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 25,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/constants/util_functions.dart';
import 'package:touchbase/features/store/screens/product.dart';
import 'package:touchbase/features/store/services/product_services.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final num price;
  const ProductCard(
      {super.key,
      required this.id,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.price});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final random = Random();
  final List<Color> colorList = [
    const Color.fromARGB(255, 255, 241, 232),
    const Color.fromARGB(255, 255, 234, 234),
    const Color.fromARGB(255, 254, 237, 255),
    const Color.fromARGB(255, 219, 255, 228),
    const Color.fromARGB(255, 232, 238, 255),
    const Color.fromARGB(255, 244, 255, 206),
    const Color.fromARGB(255, 216, 255, 239),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductScreen.routeName, arguments: {"id": widget.id});
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 206, 206, 206), width: 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(color: colorList[Random().nextInt(7)]),
                  ),
                ),
                Center(
                    child: FadeInImage.memoryNetwork(
                  image: widget.imageUrl,
                  height: 260,
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
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.description,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "₹${UtilFunctions().formatNumberWithCommas(widget.price)}",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showDialog<String>(
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
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ))
                                          : TextButton(
                                              onPressed: () async {
                                                setState(() {
                                                  isDeleting = true;
                                                });
                                                ServiceReturnType res = await ProductServices()
                                                    .deleteProduct(id: widget.id, context: context);
                                                if (res.data && context.mounted) {
                                                  Navigator.pop(context);
                                                } else {
                                                  if (res.errorMessage != null) {
                                                    showCustomSnackBar(context: context, message: res.errorMessage!);
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
                      },
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color.fromARGB(255, 205, 20, 7),
                        size: 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

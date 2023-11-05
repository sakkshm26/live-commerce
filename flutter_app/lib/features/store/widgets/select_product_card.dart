import 'dart:math';

import 'package:flutter/material.dart';
import 'package:touchbase/constants/util_functions.dart';
import 'package:touchbase/features/store/screens/product.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectProductCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final num price;
  final Function(String, String) callback;
  const SelectProductCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.callback,
  });

  @override
  State<SelectProductCard> createState() => _SelectProductCardState();
}

class _SelectProductCardState extends State<SelectProductCard> {
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
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Checkbox(
                  value: selected,
                  fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    return Colors.black;
                  }),
                  onChanged: (value) => setState(() {
                    if (selected) {
                      widget.callback(widget.id, "remove");
                    } else {
                      widget.callback(widget.id, "add");
                    }
                    selected = !selected;
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

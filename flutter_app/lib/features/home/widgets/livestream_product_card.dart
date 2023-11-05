import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class LivestreamProductCard extends StatefulWidget {
  final String title;
  final num price;
  final String imageUrl;
  final String productUrl;
  const LivestreamProductCard(
      {super.key, required this.title, required this.price, required this.imageUrl, required this.productUrl});

  @override
  State<LivestreamProductCard> createState() => _LivestreamProductCardState();
}

class _LivestreamProductCardState extends State<LivestreamProductCard> {
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
      onTap: () async {
        final Uri url = Uri.parse(widget.productUrl);
        try {
          await launchUrl(url);
        } catch (err) {
          // if (context.mounted) {
          //   showCustomSnackBar(
          //     context: context,
          //     message: "The product URL is invalid"
          //   );
          // }
          debugPrint("$err");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(color: colorList[Random().nextInt(7)]),
                  ),
                ),
                Center(
                    child: FadeInImage.memoryNetwork(
                  image: widget.imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                      ),
                      child: const Center(
                        child: Icon(Icons.error),
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            "₹${widget.price.toString()}",
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

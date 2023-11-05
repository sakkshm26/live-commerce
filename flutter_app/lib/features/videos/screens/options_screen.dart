import 'package:flutter/material.dart';

class OptionsScreen extends StatefulWidget {
  final String? sellerProfileImage;
  final String sellerName;
  final String description;

  @override
  const OptionsScreen({Key? key, this.sellerProfileImage, required this.sellerName, required this.description})
      : super(key: key);
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            widget.sellerProfileImage != null ? NetworkImage(widget.sellerProfileImage!) : null,
                        radius: 10,
                        backgroundColor: Colors.black,
                        child: widget.sellerProfileImage == null ? const Icon(Icons.person, size: 18) : null,
                      ),
                      const SizedBox(width: 10),
                      Text(widget.sellerName, style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.verified,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Text(
                      widget.description,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

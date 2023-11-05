import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
      ),
      body: const Center(
          child: Text(
        "Coming Soon!",
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
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

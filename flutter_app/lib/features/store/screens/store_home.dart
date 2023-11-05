import 'package:flutter/material.dart';
import 'package:touchbase/common/widgets/primary_button.dart';
import 'package:touchbase/features/store/screens/products.dart';
import 'package:touchbase/features/store/screens/add_or_edit_product.dart';
import 'package:touchbase/features/store/screens/start_livestream.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Store Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, StartLivestreamScreen.routeName);
              },
              title: "Start Livestream",
              isLoading: false,
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, ProductsScreen.routeName);
              },
              title: "See product list",
              isLoading: false,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

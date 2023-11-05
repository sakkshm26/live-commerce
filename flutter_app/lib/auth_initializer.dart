import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/features/home/screens/home.dart';
import 'package:touchbase/features/profile/screens/profile.dart';
import 'package:touchbase/features/store/screens/store_home.dart';
import 'package:touchbase/features/videos/screens/videos.dart';
import 'package:touchbase/features/wishlist/screens/wishlist.dart';
import 'package:touchbase/providers/user_provider.dart';

class AuthInitializerScreen extends StatefulWidget {
  AuthInitializerScreen({super.key});

  @override
  State<AuthInitializerScreen> createState() => _AuthInitializerScreenState();
}

class _AuthInitializerScreenState extends State<AuthInitializerScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> buyerScreens = [
    const HomeScreen(),
    Videos(),
    // const WishlistScreen(),
    const ProfileScreen()
  ];
  List<Tab> buyerBottomBarIcons = [
    const Tab(icon: Icon(Iconsax.home_1)),
    const Tab(icon: Icon(Iconsax.video)),
    // const Tab(icon: Icon(Iconsax.heart)),
    const Tab(icon: Icon(Iconsax.profile_circle)),
  ];
  List<Widget> sellerScreens = [const HomeScreen(), Videos(), const StoreHomeScreen(), const ProfileScreen()];
  List<Tab> sellerBottomBarIcons = [
    const Tab(icon: Icon(Iconsax.home_1)),
    const Tab(icon: Icon(Iconsax.video)),
    const Tab(icon: Icon(Iconsax.shop)),
    const Tab(icon: Icon(Iconsax.profile_circle)),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isSeller = userProvider.user?.sellerId != null;
    _tabController = TabController(length: isSeller ? 4 : 3, vsync: this);

    List<Widget> screens = isSeller ? sellerScreens : buyerScreens;
    List<Tab> bottomBarItems = isSeller ? sellerBottomBarIcons : buyerBottomBarIcons;

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: screens,
      ),
      backgroundColor: Colors.black38,
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: bottomBarItems,
        labelColor: Colors.white,
        indicatorColor: const Color(0xFFE6F339),
      ),
    );
  }
}

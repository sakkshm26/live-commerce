import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:touchbase/common/widgets/primary_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/auth/screens/phone.dart';
import 'package:touchbase/features/auth/screens/signup_info.dart';
import 'package:touchbase/features/auth/services/auth_service.dart';
import 'package:touchbase/features/profile/screens/privacy_policy.dart';
import 'package:touchbase/features/profile/services/profileServices.dart';
import 'package:touchbase/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  late UserProvider _userProvider;
  dynamic user;
  var loading = true;
  int switchValue = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  void getUserDate() async {
    var data = await ProfileServices().getProfileData(context: context, token: _userProvider.user!.token);

    if (data == null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Something went wrong when getting your profile data");
      }
    } else {
      user = data;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_userProvider.user != null) {
      getUserDate();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_userProvider.user != null) {
      getUserDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              _openDrawer();
            },
          ),
        ),
        actions: user != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 14),
                  child: Row(
                    children: [
                      user["seller_id"] == null
                          ? RawMaterialButton(
                              onPressed: () {},
                              fillColor: const Color(0xFF363342),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const SizedBox(
                                width: 120,
                                height: 20,
                                child: Center(
                                  child: Text(
                                    "Apply To Sell",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            )
                    ],
                  ),
                ),
              ]
            : [],
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                await launchUrl(Uri.parse("https://www.sakkshm.dev/touchbase/privacy-policy"));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text(
                'How to Use',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                AuthService().logout(context: context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Provider.of<UserProvider>(context).user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    title: "Login",
                    onPressed: () async {
                      await initializeFirebase();
                      if (context.mounted) {
                        Navigator.pushNamed(context, PhoneScreen.routeName, arguments: {"screenType": "login"});
                      }
                    },
                    isLoading: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  PrimaryButton(
                    title: "Sign Up",
                    onPressed: () async {
                      await initializeFirebase();
                      if (context.mounted) {
                        Navigator.pushNamed(context, SignupScreen.routeName, arguments: {"screenType": "signup"});
                      }
                    },
                    isLoading: false,
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              )
            : loading
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Iconsax.profile_circle,
                              size: 70,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              user!["username"],
                              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(children: [
                                  Text(
                                    "${user["followers"]}",
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  const Text(
                                    " followers",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("|"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(children: [
                                  Text(
                                    "${user["following"]}",
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  const Text(
                                    " following",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AnimatedToggleSwitch<int>.size(
                              current: switchValue,
                              values: const [0, 1],
                              iconOpacity: 0.2,
                              indicatorSize: const Size.fromWidth(150),
                              iconAnimationType: AnimationType.onHover,
                              indicatorAnimationType: AnimationType.onHover,
                              iconBuilder: (value, size) {
                                if (value.isEven) {
                                  return const Center(
                                      child: Text(
                                    "Buyer",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                                  ));
                                } else {
                                  return const Center(
                                      child: Text(
                                    "Seller",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                                  ));
                                }
                              },
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              colorBuilder: (i) => i.isEven == true
                                  ? const Color.fromARGB(255, 211, 211, 211)
                                  : const Color.fromARGB(255, 211, 211, 211),
                              onChanged: (i) {
                                setState(() => switchValue = i);
                              },
                            ),
                            /* const SizedBox(
                              height: 20,
                            ),
                            switchValue.isEven
                                ? const Text("Buyer Data")
                                : user["seller_id"] == null
                                    ? const Text("No seller profile")
                                    : const Text("Seller Data") */
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

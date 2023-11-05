import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:touchbase/auth_initializer.dart';
import 'package:touchbase/features/auth/services/auth_service.dart';
import 'package:touchbase/features/onboarding/screens/initial_onboarding_screen.dart';
import 'package:touchbase/providers/products_provider.dart';
import 'package:touchbase/providers/user_provider.dart';
import 'package:touchbase/router.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ProductsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  void getUserData() async {
    await AuthService().getUserData(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    sqfliteFfiInit();
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Satoshi',
        appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actionsIconTheme: const IconThemeData(color: Colors.black),
        ),
      ),
      home: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : userProvider.user == null ? const InitialOnboardingScreen() : AuthInitializerScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:touchbase/common/widgets/primary_button.dart';
import 'package:touchbase/features/auth/screens/phone.dart';
import 'package:touchbase/features/auth/screens/signup_info.dart';

class InitialOnboardingScreen extends StatefulWidget {
  const InitialOnboardingScreen({super.key});

  @override
  State<InitialOnboardingScreen> createState() => _InitialOnboardingScreenState();
}

class _InitialOnboardingScreenState extends State<InitialOnboardingScreen> {
  Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
              width: 200,
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
              width: 200,
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}

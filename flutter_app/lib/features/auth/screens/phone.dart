import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:touchbase/common/widgets/custom_textfield.dart';
import 'package:touchbase/common/widgets/form_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/auth/screens/verify_otp.dart';
import 'package:touchbase/features/auth/services/auth_service.dart';

class PhoneScreen extends StatefulWidget {
  static const String routeName = '/phone';
  final String screenType;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  const PhoneScreen({super.key, required this.screenType, this.firstName, this.lastName, this.email, this.username});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  void sendOtp() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    bool isUnique = await AuthService().checkUniquePhone(context: context, phone: _phoneController.text);

    if (widget.screenType == "signup") {
      if (isUnique == false) {
        if (context.mounted) {
          showCustomSnackBar(context: context, message: "User with this phone number already exists");
          setState(() {
            isLoading = true;
          });
        }
      } else if (isUnique == true) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91${_phoneController.text}",
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resentToken) {
            Navigator.pushNamed(context, VerifyOtpScreen.routeName, arguments: {
              "screenType": "signup",
              "verificationId": verificationId,
              "phone": _phoneController.text,
              "firstName": widget.firstName,
              "lastName": widget.lastName,
              "email": widget.email,
              "username": widget.username
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    } else {
      if (isUnique == true) {
        if (context.mounted) {
          showCustomSnackBar(context: context, message: "User with this phone number does not exist");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91${_phoneController.text}",
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resentToken) {
            Navigator.pushNamed(
              context,
              VerifyOtpScreen.routeName,
              arguments: {"screenType": "login", "verificationId": verificationId, "phone": _phoneController.text},
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 23, 23),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.screenType == "signup"
                    ? const Text(
                        "Let's quickly verify it's you!",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                      )
                    : const Text(
                        "Welcome Back!",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextField(
                  controller: _phoneController,
                  hintText: "Enter Phone",
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  theme: "dark",
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FormButton(
                  onPressed: () {
                    sendOtp();
                  },
                  title: "Send OTP",
                  isLoading: isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

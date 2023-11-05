import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:touchbase/common/widgets/custom_textfield.dart';
import 'package:touchbase/common/widgets/form_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/auth/screens/gender.dart';
import 'package:touchbase/features/auth/screens/signup_info.dart';
import 'package:touchbase/features/auth/services/auth_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  static const String routeName = '/verify-otp';
  final String screenType;
  final String verificationId;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;

  const VerifyOtpScreen(
      {super.key,
      required this.screenType,
      required this.verificationId,
      this.firstName,
      this.lastName,
      this.email,
      this.username,
      required this.phone});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  void verifyOtp() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: _otpController.text);
      await auth.signInWithCredential(credential);
      if (context.mounted) {
        if (widget.screenType == "signup") {
          setState(() {
            isLoading = false;
          });

          Navigator.pushNamed(context, GenderScreen.routeName, arguments: {
            "firstName": widget.firstName,
            "lastName": widget.lastName,
            "email": widget.email,
            "username": widget.username,
            "phone": widget.phone,
          });
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          AuthService().login(context: context, phone: widget.phone);
        }
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      showCustomSnackBar(context: context, message: "Wrong OTP!");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
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
                const Text(
                  "Enter the verification code",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextField(
                  controller: _otpController,
                  hintText: "Enter OTP",
                  maxLines: 1,
                  maxLength: 6,
                  keyboardType: TextInputType.phone,
                  theme: "dark",
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FormButton(
                  onPressed: () {
                    verifyOtp();
                  },
                  title: "Verify OTP",
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

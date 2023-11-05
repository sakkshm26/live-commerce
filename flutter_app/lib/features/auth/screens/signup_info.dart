import 'package:flutter/material.dart';
import 'package:touchbase/common/widgets/custom_textfield.dart';
import 'package:touchbase/common/widgets/form_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/auth/screens/phone.dart';
import 'package:touchbase/features/auth/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup-info';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailNameController = TextEditingController();
  final TextEditingController _usernameNameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailNameController.dispose();
    _usernameNameController.dispose();
  }

  void submit() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    bool? result = await AuthService().checkUniqueUsername(context: context, username: _usernameNameController.text);
    if (result == true) {
      if (context.mounted) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Navigator.pushNamed(
          context,
          PhoneScreen.routeName,
          arguments: {
            "screenType": "signup",
            "firstName": _firstNameController.text,
            "lastName": _lastNameController.text,
            "email": _emailNameController.text,
            "username": _usernameNameController.text
          },
        );
      }
    } else if (result == false) {
      if (context.mounted) {
        setState(() {
          isLoading = false;
        });

        showCustomSnackBar(context: context, message: "Username is taken");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 23, 23),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _signupFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Let's get you started!",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomTextField(
                            controller: _firstNameController,
                            hintText: "First Name",
                            theme: "dark",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: _lastNameController,
                            hintText: "Last Name",
                            theme: "dark",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: _emailNameController,
                            hintText: "Email",
                            theme: "dark",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: _usernameNameController,
                            hintText: "Username",
                            theme: "dark",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FormButton(
              onPressed: () {
                if (_signupFormKey.currentState!.validate()) {
                  submit();
                }
              },
              title: "Sign Up",
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

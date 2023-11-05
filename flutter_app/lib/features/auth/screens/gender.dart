import 'package:flutter/material.dart';
import 'package:touchbase/common/widgets/form_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/auth/services/auth_service.dart';
import 'package:touchbase/widgets/select.dart';

class GenderScreen extends StatefulWidget {
  static const String routeName = '/gender-select';
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String phone;

  const GenderScreen(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.username,
      required this.phone});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? gender;
  bool isLoading = false;

  void signUp() async {
    if (gender == null) {
      showCustomSnackBar(context: context, message: "Select one gender");
    } else {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      AuthService().signUp(
        context: context,
        firstName: widget.firstName,
        lastName: widget.lastName,
        email: widget.email,
        username: widget.username,
        phone: widget.phone,
        gender: gender!,
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What's your gender?",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "This allows us to suggest more relevant categories.",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 207, 207, 207)),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SelectOption(
                          text: "Male",
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          active: gender == "MALE",
                          onTap: () {
                            setState(() {
                              gender = "MALE";
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SelectOption(
                          text: "Female",
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          active: gender == "FEMALE",
                          onTap: () {
                            setState(() {
                              gender = "FEMALE";
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SelectOption(
                          text: "Non-Binary",
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          active: gender == "NON_BINARY",
                          onTap: () {
                            setState(() {
                              gender = "NON_BINARY";
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FormButton(
              onPressed: () {
                signUp();
              },
              title: "Done, let's do this!",
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}

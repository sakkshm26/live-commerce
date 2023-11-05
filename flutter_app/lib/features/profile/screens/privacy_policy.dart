import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const String routeName = '/privacy-policy';
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Welcome to Touchbase, where your shopping experience is our top priority. We take your privacy seriously and want to ensure you understand how we handle and protect your data. When you use our app, you are agreeing to the following practices.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "We collect necessary information to create and manage your account, such as your name, phone and email. This information helps us personalize your experience and improve our services.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Rest assured, we prioritize your data security. Industry-standard security measures are in place to protect your data from unauthorized access.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "We do not sell, rent, or trade your personal information to third parties. Your data may be shared with trusted service providers, but only for the purposes of order fulfillment, payment processing, or to enhance our app's performance.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "As our practices and legal requirements evolve, this policy may be updated. We encourage you to review our privacy policy regularly for any changes.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

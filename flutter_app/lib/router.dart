import 'dart:io';

import 'package:flutter/material.dart';
import 'package:touchbase/features/auth/screens/gender.dart';
import 'package:touchbase/features/auth/screens/phone.dart';
import 'package:touchbase/features/auth/screens/signup_info.dart';
import 'package:touchbase/features/auth/screens/verify_otp.dart';
import 'package:touchbase/features/home/screens/livestream_view.dart';
import 'package:touchbase/features/profile/screens/privacy_policy.dart';
import 'package:touchbase/features/profile/screens/profile.dart';
import 'package:touchbase/features/store/screens/product.dart';
import 'package:touchbase/features/store/screens/products.dart';
import 'package:touchbase/features/store/screens/add_or_edit_product.dart';
import 'package:touchbase/features/store/screens/livestream.dart';
import 'package:touchbase/features/store/screens/select_lievestream_products.dart';
import 'package:touchbase/features/store/screens/start_livestream.dart';

PageRouteBuilder createPageRouteBuilder(Widget screen, String name) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
      settings: RouteSettings(name: name));
}

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case ProfileScreen.routeName:
      return createPageRouteBuilder(const ProfileScreen(), ProfileScreen.routeName);

    case SignupScreen.routeName:
      return createPageRouteBuilder(const SignupScreen(), SignupScreen.routeName);

    case PhoneScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String screenType = arguments['screenType'];

      if (screenType == "signup") {
        final String firstName = arguments['firstName'];
        final String lastName = arguments['lastName'];
        final String email = arguments['email'];
        final String username = arguments['username'];
        return createPageRouteBuilder(
            PhoneScreen(
              screenType: screenType,
              firstName: firstName,
              lastName: lastName,
              email: email,
              username: username,
            ),
            PhoneScreen.routeName);
      } else {
        return createPageRouteBuilder(
            PhoneScreen(
              screenType: screenType,
            ),
            PhoneScreen.routeName);
      }

    case VerifyOtpScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String verificationId = arguments['verificationId'];
      final String screenType = arguments['screenType'];
      final String phone = arguments['phone'];

      if (screenType == "signup") {
        final String firstName = arguments['firstName'];
        final String lastName = arguments['lastName'];
        final String email = arguments['email'];
        final String username = arguments['username'];
        final String phone = arguments['phone'];
        return createPageRouteBuilder(
            VerifyOtpScreen(
              screenType: screenType,
              verificationId: verificationId,
              phone: phone,
              firstName: firstName,
              lastName: lastName,
              email: email,
              username: username,
            ),
            VerifyOtpScreen.routeName);
      } else {
        return createPageRouteBuilder(
            VerifyOtpScreen(
              screenType: screenType,
              verificationId: verificationId,
              phone: phone,
            ),
            VerifyOtpScreen.routeName);
      }

    case GenderScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String firstName = arguments['firstName'];
      final String lastName = arguments['lastName'];
      final String email = arguments['email'];
      final String username = arguments['username'];
      final String phone = arguments['phone'];
      return createPageRouteBuilder(
          GenderScreen(
            firstName: firstName,
            lastName: lastName,
            email: email,
            username: username,
            phone: phone,
          ),
          GenderScreen.routeName);

    // Livestream routes

    case StartLivestreamScreen.routeName:
      return createPageRouteBuilder(const StartLivestreamScreen(), StartLivestreamScreen.routeName);

    case LivestreamScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String title = arguments["title"];
      final File? image = arguments["image"];
      final List<String> selectedProductIds = arguments["selected_product_ids"];
      return createPageRouteBuilder(
          LivestreamScreen(
            title: title,
            image: image,
            selectedProductIds: selectedProductIds,
          ),
          LivestreamScreen.routeName);

    case SelectLivestreamProductScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String title = arguments["title"];
      final File? image = arguments["image"];
      return createPageRouteBuilder(
          SelectLivestreamProductScreen(
            title: title,
            image: image,
          ),
          SelectLivestreamProductScreen.routeName);

    // Home routes
    case LivestreamViewScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String livestreamID = arguments['livestreamID'];
      return createPageRouteBuilder(
          LivestreamViewScreen(
            livestreamID: livestreamID,
          ),
          LivestreamViewScreen.routeName);

    // Product routes
    case AddOrEditProductScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String type = arguments['type'];
      final String? id = arguments['id'];
      final String? title = arguments['title'];
      final String? description = arguments['description'];
      final num? price = arguments['price'];
      final String? productUrl = arguments['productUrl'];
      return createPageRouteBuilder(
          AddOrEditProductScreen(
            id: id,
            type: type,
            title: title,
            description: description,
            price: price,
            productUrl: productUrl,
          ),
          AddOrEditProductScreen.routeName);

    case ProductsScreen.routeName:
      return createPageRouteBuilder(const ProductsScreen(), ProductsScreen.routeName);

    case ProductScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final String id = arguments["id"];
      return createPageRouteBuilder(
        ProductScreen(
          id: id,
        ),
        ProductScreen.routeName,
      );

    case PrivacyPolicyPage.routeName:
      return createPageRouteBuilder(const PrivacyPolicyPage(), PrivacyPolicyPage.routeName);

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}

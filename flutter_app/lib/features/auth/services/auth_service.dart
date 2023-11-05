import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchbase/constants/error_handler.dart';
import 'package:touchbase/constants/global_variables.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/providers/user_provider.dart';

class AuthService {
  Future getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? buyerId = prefs.getString('buyer_id');

      if (token != null && buyerId != null) {
        http.Response res = await http.get(Uri.parse('${GlobalVariables.uri}/user'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        });

        if (context.mounted) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(res.body);

          return res.body;

          // await prefs.setString('token', jsonDecode(res.body)['token']);
          // await prefs.setString('buyer_id', jsonDecode(res.body)['buyer_id']);
          // if (jsonDecode(res.body)['seller_id'] != null) {
          //   await prefs.setString('seller_id', jsonDecode(res.body)['seller_id']);
          // }
        }
      }
    } catch (e) {
      return null;
      // showCustomSnackBar(context: context, message: e.toString());
    }
  }

  Future checkUniquePhone({required BuildContext context, required String phone}) async {
    try {
      http.Response res = await http.post(Uri.parse('${GlobalVariables.uri}/user/check/phone'),
          body: jsonEncode({"phone": phone}),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

      if (context.mounted) {
        if (res.statusCode == 200) {
          return true;
        } else if (res.statusCode == 404) {
          return false;
        } else {
          showCustomSnackBar(context: context, message: "Something went wrong when checking the phone number");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      showCustomSnackBar(context: context, message: e.toString());
      return null;
    }
  }

  Future checkUniqueUsername({required BuildContext context, required String username}) async {
    try {
      http.Response res = await http.post(Uri.parse('${GlobalVariables.uri}/user/check/username'),
          body: jsonEncode({"username": username}),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

      if (context.mounted) {
        if (res.statusCode == 200) {
          return true;
        } else if (res.statusCode == 404) {
          return false;
        } else {
          showCustomSnackBar(context: context, message: "Something went wrong when checking the phone number");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      showCustomSnackBar(context: context, message: e.toString());
      return null;
    }
  }

  void signUp({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String phone,
    required String gender,
  }) async {
    try {
      final user = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "username": username,
        "phone": phone,
        "gender": gender
      };

      http.Response res = await http.post(Uri.parse('${GlobalVariables.uri}/auth/signup'),
          body: json.encode(user), headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'});

      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonDecode(res.body)['token']);
        await prefs.setString('buyer_id', jsonDecode(res.body)['buyer_id']);
        if (jsonDecode(res.body)['seller_id'] != null) {
          await prefs.setString('seller_id', jsonDecode(res.body)['seller_id']);
        }
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        }
      } else {
        if (context.mounted) {
          showCustomSnackBar(context: context, message: "Something went wrong during signup");
        }
      }
    } catch (e) {
      showCustomSnackBar(context: context, message: e.toString());
    }
  }

  void login({required BuildContext context, required String phone}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${GlobalVariables.uri}/auth/login'),
        body: json.encode({"phone": phone}),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonDecode(res.body)['token']);
        await prefs.setString('buyer_id', jsonDecode(res.body)['buyer_id']);
        if (jsonDecode(res.body)['seller_id'] != null) {
          await prefs.setString('seller_id', jsonDecode(res.body)['seller_id']);
        }
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        }
      } else {
        if (context.mounted) {
          showCustomSnackBar(context: context, message: "Something went wrong during login");
        }
      }
    } catch (e) {
      showCustomSnackBar(context: context, message: e.toString());
    }
  }

  void logout({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false).clearUser();
      }
    } catch (e) {
      showCustomSnackBar(context: context, message: e.toString());
    }
  }
}

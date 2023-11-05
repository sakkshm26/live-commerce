import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:touchbase/providers/user_provider.dart';

class ProfileServices {
  Future? getProfileData({required BuildContext context, required String token}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${GlobalVariables.uri}/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${token}"
        },
      );

      return jsonDecode(res.body);
    } catch (e) {
      return null;
    }
  }
}
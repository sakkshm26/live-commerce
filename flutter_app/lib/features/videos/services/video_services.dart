import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:touchbase/constants/global_variables.dart';

class VideoServices {
  Future getVideos() async {
    try {
      var client = http.Client();
      var uri = GlobalVariables.uri;
      var response = await client.get(Uri.parse("$uri/video"));
      debugPrint(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }
}
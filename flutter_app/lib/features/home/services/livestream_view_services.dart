import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/constants/util_functions.dart';
import 'package:touchbase/providers/user_provider.dart';

// TODO: use a class for defining the return type for all functions
class ReturnType {
  final Map<String, dynamic>? roomInfo;
  final String? errorMessage;

  ReturnType({this.roomInfo, this.errorMessage});
}

class LivestreamViewServices {
  Future getLivestreams() async {
    try {
      var client = http.Client();
      var uri = GlobalVariables.uri;
      var response = await client.get(Uri.parse("$uri/livestream/get-list"));
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<ReturnType> joinLivestream(BuildContext context, String livestreamId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('${GlobalVariables.uri}/livestream/join'),
        body: jsonEncode({"livestream_id": livestreamId}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${userProvider.user!.token}"
        },
      );

      if (res.statusCode == 410) {
        return ReturnType(errorMessage: "ENDED");
      }

      var json = jsonDecode(res.body);

      final room = Room();
      final listener = room.createListener();

      await room.connect(
        "wss://first-app-jcllwzee.livekit.cloud",
        json["livekit_token"],
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultCameraCaptureOptions: CameraCaptureOptions(
            maxFrameRate: 30,
            params: VideoParameters(
              dimensions: VideoDimensionsPresets.h720_169,
              encoding: VideoEncoding(
                maxBitrate: 2 * 1000 * 1000,
                maxFramerate: 30,
              ),
            ),
          ),
        ),
      );

      return ReturnType(roomInfo: {"room": room, "listener": listener});
    } catch (err) {
      debugPrint("$err");
      return ReturnType(errorMessage: "ERROR");
    }
  }

  Future<ServiceReturnType> getLivestreamProducts({required BuildContext context, required String livestreamId}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.get(
        Uri.parse('${GlobalVariables.uri}/livestream/$livestreamId/products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${userProvider.user!.token}"
        },
      );

      var jsonData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return ServiceReturnType(data: jsonData);
      } else {
        return ServiceReturnType(errorMessage: "Something went wrong when getting livestream products");
      }
    } catch (err) {
      debugPrint("$err");
      return ServiceReturnType(errorMessage: "Something went wrong when getting livestream products");
    }
  }
}

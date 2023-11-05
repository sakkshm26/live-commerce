import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/store/screens/livestream.dart';
import "package:http/http.dart" as http;
import 'package:touchbase/constants/global_variables.dart';
import 'package:touchbase/providers/user_provider.dart';

class LivestreamServices {
  Future<Map<String, dynamic>?> startLivestream(
      {required BuildContext context, required dynamic data, required List<String> selectedProductIds}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      var microphoneStatus = await Permission.microphone.request();
      if (!microphoneStatus.isGranted) {
        if (context.mounted) {
          showCustomSnackBar(context: context, message: "Enable microphone permission for starting a livestream");
        }
        return null;
      }

      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        if (context.mounted) {
          showCustomSnackBar(context: context, message: "Enable camera permission for starting a livestream");
        }
        return null;
      }

      var request = http.MultipartRequest("POST", Uri.parse('${GlobalVariables.uri}/livestream/create'));

      request.fields["seller_id"] = userProvider.user!.sellerId!;
      request.fields["title"] = data["title"];
      request.headers["Authorization"] = "Bearer ${userProvider.user!.token}";

      for (var i = 0; i < selectedProductIds.length; i++) {
        request.fields['selected_product_ids[$i]'] = selectedProductIds[i];
      }

      if (data["image"] != null) {
        var pic = await http.MultipartFile.fromPath("image", data["image"].path);
        request.files.add(pic);
      }

      var response = await request.send();

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      var jsonData = jsonDecode(responseString);

      final room = Room();
      final listener = room.createListener();

      await room.connect(
        "wss://first-app-jcllwzee.livekit.cloud",
        jsonData["livekit_token"],
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

      return {"room": room, "listener": listener};
    } catch (err) {
      debugPrint("$err");
      showCustomSnackBar(context: context, message: "Something went wrong when creating the livestream");
      return null;
    }
  }

  Future endLivestream({required String token, required String roomName}) async {
    try {
      await http.post(
        Uri.parse('${GlobalVariables.uri}/livestream/end'),
        body: jsonEncode({"room_name": roomName}),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": "Bearer $token"},
      );
    } catch (err) {
      debugPrint("$err");
      // showCustomSnackBar(context: context, message: "Something went wrong!");
    }
  }
}

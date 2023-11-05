import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class ControlsWidget extends StatefulWidget {
  final Room room;
  const ControlsWidget({super.key, required this.room});

  @override
  State<ControlsWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  var cameraEnabled = false;
  var micEnabled = false;

  Future<void> toggleMic() async {
    if (!micEnabled) {
      await widget.room.localParticipant!.setMicrophoneEnabled(true);
      micEnabled = true;
    } else {
      await widget.room.localParticipant!.setMicrophoneEnabled(false);
      micEnabled = false;
    }
    setState(() {});
  }

  Future<void> toggleCamera() async {
    if (!cameraEnabled) {
      await widget.room.localParticipant!.setCameraEnabled(true);
      cameraEnabled = true;
    } else {
      await widget.room.localParticipant!.setCameraEnabled(false);
      cameraEnabled = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      IconButton(
          onPressed: toggleMic,
          icon: micEnabled
              ? const Icon(
                  Icons.mic,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.mic_off,
                  color: Colors.black,
                )),
      const SizedBox(
        width: 10,
      ),
      IconButton(
        onPressed: toggleCamera,
        icon: cameraEnabled
            ? const Icon(Icons.videocam, color: Colors.black,)
            : const Icon(Icons.videocam_off, color: Colors.black,)
      ),
    ]);
  }
}

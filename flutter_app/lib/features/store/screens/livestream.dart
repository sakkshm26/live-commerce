import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/features/store/services/livestream_services.dart';

import 'package:touchbase/features/store/widgets/participant_info.dart';
import 'package:touchbase/features/store/widgets/controls.dart';
import 'package:touchbase/providers/user_provider.dart';

class LivestreamScreen extends StatefulWidget {
  static const String routeName = '/livestream';
  final String title;
  final File? image;
  final List<String> selectedProductIds;

  const LivestreamScreen({super.key, required this.title, this.image, required this.selectedProductIds});

  @override
  State<LivestreamScreen> createState() => LivestreamScreenState();
}

class LivestreamScreenState extends State<LivestreamScreen> {
  List streamerTracks = [];
  Room? room;
  EventsListener<RoomEvent>? listener;
  EventsListener<RoomEvent>? get _listener => listener;
  late UserProvider _userProvider;
  var isLoaded = false;

  Future<void> initRoom() async {
    Map<String, dynamic>? res = await LivestreamServices()
        .startLivestream(context: context, data: {"title": widget.title, "image": widget.image}, selectedProductIds: widget.selectedProductIds);
    if (res != null) {
      room = res["room"];
      listener = res["listener"];
      room!.addListener(_onRoomDidUpdate);
      _setUpListeners();
      _sortParticipants();
      setState(() {
        isLoaded = true;
      });
    }
  }

  void _setUpListeners() => _listener!
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        debugPrint('Room disconnected: reason => ${event.reason}');
      }
      WidgetsBindingCompatible.instance?.addPostFrameCallback((timeStamp) => Navigator.pop(context));
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants());

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _sortParticipants() {
    List<ParticipantTrack> tempStreamerTracks = [];

    final localParticipantTracks = room!.localParticipant?.videoTracks;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
        {
          tempStreamerTracks.add(ParticipantTrack(
            participant: room!.localParticipant!,
            videoTrack: t.track,
            isScreenShare: false,
          ));
        }
      }
    }

    setState(() {
      streamerTracks = tempStreamerTracks;
    });
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    initRoom();
  }

  @override
  void dispose() {
    (() async {
      if (room != null) {
        room!.removeListener(_onRoomDidUpdate);
        LivestreamServices().endLivestream(token: _userProvider.user!.token, roomName: room!.name!);
        await _listener!.dispose();
        await room!.disconnect();
        await room!.dispose();
      }
    })();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.red,
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: room == null
            ? null
            : [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(room!.participants.length.toString())
                    ],
                  ),
                ),
              ],
      ),
      body: Stack(
        children: [
          isLoaded
              ? Column(
                  children: [
                    Expanded(
                      child: streamerTracks.isNotEmpty && room!.localParticipant!.isCameraEnabled()
                          ? VideoTrackRenderer(
                              streamerTracks.first.videoTrack!,
                              fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            )
                          : Container(
                              color: Colors.black,
                            ),
                    ),
                    if (room!.localParticipant != null)
                      SafeArea(
                        top: false,
                        child: ControlsWidget(room: room!),
                      ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.black,),
                ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart' hide ConnectionState;
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/constants/util_functions.dart';
import 'package:touchbase/features/home/services/livestream_view_services.dart';
import 'package:touchbase/features/home/widgets/livestream_product_card.dart';

import 'package:touchbase/features/store/widgets/participant_info.dart';

//TODO: don't allow a buyer to join a room which the seller has left

class LivestreamViewScreen extends StatefulWidget {
  static const String routeName = '/livestream-view';
  final String livestreamID;
  const LivestreamViewScreen({super.key, required this.livestreamID});

  @override
  State<LivestreamViewScreen> createState() => _LivestreamViewScreenState();
}

class _LivestreamViewScreenState extends State<LivestreamViewScreen> {
  List streamerTracks = [];
  Room? room;
  EventsListener<RoomEvent>? listener;
  EventsListener<RoomEvent>? get _listener => listener;
  final TextEditingController _messageController = TextEditingController();
  var isLoaded = false;
  var isEnded = false;
  bool cameraEnabled = true;

  Future<void> initRoom() async {
    ReturnType res = await LivestreamViewServices().joinLivestream(context, widget.livestreamID);
    if (res.errorMessage == "ENDED") {
      if (mounted) {
        setState(() {
          isEnded = true;
          isLoaded = true;
        });
      }
    } else if (res.errorMessage == "ERROR") {
      if (mounted) showCustomSnackBar(context: context, message: "Something went wrong when joining the livestream");
    } else {
      room = res.roomInfo!["room"];
      listener = res.roomInfo!["listener"];
      room!.addListener(_onRoomDidUpdate);
      _setUpListeners();
      _sortParticipants();
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  Future<dynamic> getProducts() async {
    ServiceReturnType res =
        await LivestreamViewServices().getLivestreamProducts(context: context, livestreamId: widget.livestreamID);

    if (res.data != null) {
      return res.data;
    } else if (res.errorMessage != null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: res.errorMessage!);
      }
    }
  }

  void _setUpListeners() => _listener!
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        // debugPrint('Room disconnected: reason => ${event.reason}');
      }
      WidgetsBindingCompatible.instance?.addPostFrameCallback((timeStamp) => {
            if (mounted) {Navigator.popUntil(context, (route) => route.isFirst)}
          });
    })
    ..on<ParticipantEvent>((event) {
      debugPrint('-----------> Participant event $event');
      if (event is TrackUnmutedEvent && event.publication.source == TrackSource.camera ||
          event is TrackStreamStateUpdatedEvent) {
        if (mounted) {
          setState(() {
            cameraEnabled = true;
          });
        }
      } else if (event is TrackMutedEvent && event.publication.source == TrackSource.camera) {
        if (mounted) {
          setState(() {
            cameraEnabled = false;
          });
        }
      }
      _sortParticipants();
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<DataReceivedEvent>((data) {
      // debugPrint("Data is ----------> ${data.data}");
    });

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _sortParticipants() {
    List<ParticipantTrack> tempStreamerTracks = [];
    for (var participant in room!.participants.values) {
      // debugPrint("Adding --------------> $participant");
      for (var t in participant.videoTracks) {
        tempStreamerTracks.add(ParticipantTrack(
          participant: participant,
          videoTrack: t.track,
          isScreenShare: false,
        ));
      }
    }

    if (mounted) {
      setState(() {
        streamerTracks = tempStreamerTracks;
      });
    }
  }

  void sendMessage(String text) async {
    await room!.localParticipant?.publishData(utf8.encode(text), reliability: Reliability.reliable);
  }

  @override
  void initState() {
    super.initState();

    initRoom();
  }

  @override
  void dispose() {
    (() async {
      if (room != null) {
        room!.removeListener(_onRoomDidUpdate);
        await _listener!.dispose();
        await room!.disconnect();
        await room!.dispose();
      }
      _messageController.dispose();
    })();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              elevation: 2,
              builder: (BuildContext context) {
                return FutureBuilder(
                  future: getProducts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black,),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const SizedBox(
                        height: 400,
                        child: Center(
                          child: Text('Error fetching data'),
                        ),
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Center(
                          child: snapshot.data.length == 0 ? const Text("No products available") : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 0.65, mainAxisSpacing: 20, crossAxisSpacing: 20),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return LivestreamProductCard(
                                  imageUrl: snapshot.data[index]["image_url"],
                                  price: snapshot.data[index]["price"],
                                  title: snapshot.data[index]["title"],
                                  productUrl: snapshot.data[index]["product_url"]);
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
          child: const Text(
            "All Products",
            style: TextStyle(color: Color(0xFFE6F339), fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Stack(
        children: [
          isLoaded
              ? isEnded
                  ? const Center(
                      child: Text("The livestream has ended"),
                    )
                  : streamerTracks.isNotEmpty && cameraEnabled && streamerTracks.first?.videoTrack != null
                      ? VideoTrackRenderer(
                          streamerTracks.first.videoTrack,
                          fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )
                      : Container(
                          color: Colors.black,
                        )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.black,),
                ),
        ],
      ),
    );
  }
}

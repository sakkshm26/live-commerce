import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:touchbase/features/videos/screens/options_screen.dart';
import 'package:video_player/video_player.dart';

class ContentScreen extends StatefulWidget {
  final String videoUrl;
  final String? sellerProfileImage;
  final String sellerName;
  final String description;

  const ContentScreen(
      {Key? key, required this.videoUrl, this.sellerProfileImage, required this.sellerName, required this.description})
      : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? Container(
                color: Colors.black,
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ],
              ),
        OptionsScreen(
          sellerName: widget.sellerName,
          sellerProfileImage: widget.sellerProfileImage,
          description: widget.description,
        )
      ],
    );
  }
}

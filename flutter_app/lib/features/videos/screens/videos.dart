import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/videos/screens/content_screen.dart';
import 'package:touchbase/features/videos/services/video_services.dart';

class Videos extends StatefulWidget {
  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  /* final List<String> videos = [
    "https://www.shutterstock.com/shutterstock/videos/1044255715/preview/stock-footage-person-signing-important-document-camera-following-tip-of-the-pen-as-it-signs-crucial-business.webm",
    'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  ]; */

  List videos = [];
  var isLoaded = false;

  Future<void> getData() async {
    videos = await VideoServices().getVideos();
    if (videos == null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Something went wrong");
      }
    } else {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoaded
            ? videos.isEmpty
                ? const Center(
                    child: Text("No videos available!"),
                  )
                : Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ContentScreen(
                      videoUrl: videos[index]["video_url"],
                      sellerProfileImage: videos[index]["seller_profile_image"],
                      sellerName: videos[index]["seller_name"],
                      description: videos[index]["description"],
                    );
                  },
                  itemCount: videos.length,
                  scrollDirection: Axis.vertical,
                )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}

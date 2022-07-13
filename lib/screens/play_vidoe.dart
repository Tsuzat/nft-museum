import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//* This is not very optimised solution to have multiple video_player
//* putting this on hold

class PlayVideo extends StatefulWidget {
  final String url;
  const PlayVideo({Key? key, required this.url}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      widget.url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((_) {
        controller.setLooping(true);
        controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(255, 255, 255, 0.6),
              ),
            ),
    );
  }
}

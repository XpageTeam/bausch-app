import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryBackground extends StatelessWidget {
  final StoryContentModel story;
  final VideoPlayerController videoPlayerController;
  const StoryBackground({
    required this.story,
    required this.videoPlayerController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (story.isVideo) {
      case false:
        return ExtendedImage.network(
          story.file ?? story.preview,
          fit: BoxFit.cover,
          printError: false,
          loadStateChanged: loadStateChangedFunction,
        );
      case true:
        if (videoPlayerController.value.isInitialized) {
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoPlayerController.value.size.width,
              height: videoPlayerController.value.size.height,
              child: VideoPlayer(videoPlayerController),
            ),
          );
        }
    }
    return ExtendedImage.network(
      story.preview,
      fit: BoxFit.cover,
      printError: false,
      loadStateChanged: loadStateChangedFunction,
      //color: Colors.red.withAlpha(10),
    );
  }
}

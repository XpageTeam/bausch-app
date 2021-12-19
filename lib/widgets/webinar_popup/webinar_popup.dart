import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:vimeoplayer_trinity/vimeoplayer_trinity.dart';

class VimeoPopup extends StatelessWidget {
  final String videoId;
  const VimeoPopup({
    required this.videoId,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    debugPrint('videoId: $videoId');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VimeoPlayer(
            id: videoId,
            autoPlay: true,
            loaderWidget: const AnimatedLoader(),
          ),
        ],
      ),
    );
  }
}

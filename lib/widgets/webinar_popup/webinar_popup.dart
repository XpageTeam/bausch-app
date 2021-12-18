import 'package:bausch/theme/app_theme.dart';
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
    debugPrint('id: $videoId');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VimeoPlayer(
            id: videoId,
            autoPlay: true,
            loaderColor: AppTheme.turquoiseBlue,
          ),
        ],
      ),
    );
  }
}

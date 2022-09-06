import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/sections/sheets/screens/webinars/final_webinar.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:vimeoplayer_trinity/vimeoplayer_trinity.dart';

class WebinarPopup extends StatelessWidget {
  final String videoId;
  const WebinarPopup({required this.videoId, Key? key}) : super(key: key);

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
            onError: () {
              Navigator.of(context).pop();
              showTopError(
                const CustomException(title: 'Не удалось воспроизвести видео'),
              );
            },
          ),
        ],
      ),
    );
  }
}

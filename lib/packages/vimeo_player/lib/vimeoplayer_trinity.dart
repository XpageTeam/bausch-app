library vimeoplayer;

import 'package:bausch/packages/better_player/lib/better_player.dart';
import 'package:bausch/packages/vimeo_player/lib/src/controls_config.dart';
import 'package:bausch/packages/vimeo_player/lib/src/quality_links.dart';
import 'package:flutter/material.dart';

//Video player class
class VimeoPlayer extends StatefulWidget {
  /// Vimeo video id
  final String? id;

  /// Whether player should autoplay video
  final bool autoPlay;

  /// Whether player should loop video
  final bool looping;

  /// Start playing in fullscreen.default is false
  final bool allowFullScreen;

  /// Configure controls
  final BetterPlayerControlsConfiguration? controlsConfig;

  /// Progress indicator color
  final Color? loaderColor;

  /// Progress indicator background color
  final Color? loaderBackgroundColor;

  VimeoPlayer({
    required this.id,
    this.autoPlay = false,
    this.looping = false,
    this.controlsConfig,
    this.loaderColor,
    this.loaderBackgroundColor,
    this.allowFullScreen = false,
    Key? key,
  })  : assert(id != null),
        super(key: key);

  @override
  _VimeoPlayerState createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  int? position;
  bool fullScreen = false;

  //Quality Class
  late QualityLinks _quality;
  dynamic _qualityValue;
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    fullScreen = widget.allowFullScreen;

    //Create class
    _quality = QualityLinks(widget.id);

    //Initializing video controllers when receiving data from Vimeo
    _quality.getQualitiesSync().then((value) {
      _qualityValue = value![value.lastKey()];

      // Create resolutions map
      final resolutionsMap = <String, dynamic>{};
      value.keys.forEach((dynamic key) {
        final processedKey = (key as String).split(' ')[0];
        resolutionsMap[processedKey] = value[key] as String;
      });

      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        _qualityValue as String,
        resolutions: resolutionsMap.cast<String, String>(),
      );

      setState(() {
        _betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: widget.autoPlay,
            looping: widget.looping,
            fullScreenByDefault: fullScreen,
            controlsConfiguration: widget.controlsConfig == null
                ? ControlsConfig()
                : widget.controlsConfig!,
          ),
          betterPlayerDataSource: betterPlayerDataSource,
        );
      });

      //Update orientation and rebuilding page
      // setState(() {
      //   SystemChrome.setPreferredOrientations(
      //       [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      // });
    });

    // //The video page takes precedence over portrait orientation
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.initState();
  }

  //Build player element
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _betterPlayerController == null
          ? CircularProgressIndicator(
              color: widget.loaderColor,
              backgroundColor: widget.loaderBackgroundColor,
            )
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController as BetterPlayerController,
              ),
            ),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    // initFuture = null;

    super.dispose();
  }
}

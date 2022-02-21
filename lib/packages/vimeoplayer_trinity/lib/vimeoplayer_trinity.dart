library vimeoplayer;

import 'dart:collection';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:vimeoplayer_trinity/src/controls_config.dart';
import 'package:vimeoplayer_trinity/src/quality_links.dart';

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

  final Widget? loaderWidget;

  final VoidCallback onError;

  const VimeoPlayer({
    required this.id,
    required this.onError,
    this.autoPlay = false,
    this.looping = false,
    this.controlsConfig,
    this.loaderColor,
    this.loaderBackgroundColor,
    this.allowFullScreen = false,
    this.loaderWidget,
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
  String? _qualityValue;
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    fullScreen = widget.allowFullScreen;

    //Create class
    _quality = QualityLinks(widget.id);

    //Initializing video controllers when receiving data from Vimeo
    _quality.getQualitiesSync().then((dynamic value) {
      value as SplayTreeMap<String, String>?;

      _qualityValue = value != null ? value[value.lastKey()] : null;

      // Create resolutions map
      final resolutionsMap = SplayTreeMap<String, String>();
      if (value != null) {
        for (final key in value.keys) {
          final processedKey = key.split(' ')[0];
          resolutionsMap[processedKey] = value[key]!;
        }
      } else {
        widget.onError();
      }

      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        _qualityValue!,
        resolutions: resolutionsMap,
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
          ? widget.loaderWidget
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController as BetterPlayerController,
              ),
            ),
    );
  }
}

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FinalWebinar extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  final String videoId;

  const FinalWebinar({
    required this.controller,
    required this.model,
    required this.videoId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.sulu,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CustomSliverAppbar.toClose(
                      Container(),
                      key,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Ваш доступ к записи вебинара',
                        style: AppStyles.h1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 40,
                      ),
                      child: Text(
                        'Доступ к видео у вас будет всегда, путь к нему будет в Профиле и в разделе «Записи вебинаров»',
                        style: AppStyles.p1,
                      ),
                    ),
                    BigCatalogItem(model: model),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: BottomButtonWithRoundedCorners(
          text: 'Перейти к просмотру',
          onPressed: () {
            Keys.mainNav.currentState!.pop();

            showDialog<void>(
              context: Keys.mainNav.currentContext!,
              builder: (context) => YoutubePopup(videoId: videoId),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class YoutubePopup extends CoreMwwmWidget<YoutubePopupWM> {
  YoutubePopup({
    required String videoId,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => YoutubePopupWM(
            context: context,
            videoId: videoId,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<YoutubePopupWM>, YoutubePopupWM>
      createWidgetState() => _YoutubePopupState();
}

class _YoutubePopupState extends WidgetState<YoutubePopup, YoutubePopupWM> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: wm.controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              onReady: wm.onReady,
              onEnded: (data) => wm.onEnded(data),
            ),
            builder: (context, player) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                player,
                EntityStateBuilder<YoutubePlayerController>(
                  streamedState: wm.controllerStreamed,
                  builder: (context, controller) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                onPressed: wm.isPlayerReady
                                    ? () => wm.onPause()
                                    : null,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  wm.muted ? Icons.volume_off : Icons.volume_up,
                                ),
                                onPressed:
                                    wm.isPlayerReady ? () => wm.onMute() : null,
                              ),
                              Expanded(
                                child: Slider(
                                  inactiveColor: Colors.transparent,
                                  value: wm.volume,
                                  max: 100.0,
                                  divisions: 10,
                                  label: '${(wm.volume).round()}',
                                  onChanged: wm.isPlayerReady
                                      ? (value) => wm.onVolumeChanged(value)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YoutubePopupWM extends WidgetModel {
  final BuildContext context;
  final String videoId;
  final controllerStreamed = EntityStreamedState<YoutubePlayerController>();
  final onReady = VoidAction();
  final onEnded = StreamedAction<YoutubeMetaData>();

  final onMute = VoidAction();
  final onPause = VoidAction();
  final onVolumeChanged = StreamedAction<double>();

  double volume = 100;
  double oldVolume = 100;
  bool muted = false;

  bool isPlayerReady = false;

  late YoutubePlayerController controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  YoutubePopupWM({
    required this.context,
    required this.videoId,
  }) : super(
          const WidgetModelDependencies(),
        );
  @override
  void onLoad() {
    controllerStreamed.loading();

    controller = YoutubePlayerController(
      initialVideoId: videoId,
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

    controllerStreamed.content(controller);

    super.onLoad();
  }

  @override
  void onBind() {
    onReady.bind((_) => isPlayerReady = true);

    onEnded.bind((data) {
      Navigator.of(context).pop();
    });

    onVolumeChanged.bind((value) {
      volume = value ?? volume;
      controller.setVolume(volume.round());

      if (volume == 0) {
        muted = true;
      } else {
        muted = false;
      }

      controllerStreamed.content(controller);
    });

    onMute.bind((_) {
      muted ? controller.unMute() : controller.mute();
      muted = !muted;
      if (muted) {
        oldVolume = volume;
        volume = 0;
      } else {
        volume = oldVolume;
      }
      controllerStreamed.content(controller);
    });

    onPause.bind((_) {
      {
        controller.value.isPlaying ? controller.pause() : controller.play();

        controllerStreamed.content(controller);
      }
    });

    super.onBind();
  }

  void listener() {
    if (isPlayerReady && !controller.value.isFullScreen) {
      _playerState = controller.value.playerState;
      _videoMetaData = controller.metadata;

      controllerStreamed.content(controller);
    }
  }
}

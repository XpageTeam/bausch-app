import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:better_player/src/configuration/better_player_controls_configuration.dart';
import 'package:better_player/src/controls/better_player_overflow_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:vimeoplayer_trinity/vimeoplayer_trinity.dart';

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
              builder: (context) => VimeoPopup(videoId: videoId),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

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

    try {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VimeoPlayer(
              id: '809202',
              autoPlay: true,
              loaderColor: AppTheme.turquoiseBlue,
              controlsConfig: BauschControlsConfig(
                onClose: Navigator.of(context).pop,
              ),
              loaderWidget: const AnimatedLoader(),
            ),
          ],
        ),
      );
    } on ResponseParseException catch (e) {
      return Dialog(
        elevation: 0,
        backgroundColor: AppTheme.mystic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Ошибка воспроизведения видео',
                textAlign: TextAlign.center,
                style: AppStyles.h1,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class BauschControlsConfig extends BetterPlayerControlsConfiguration {
  BauschControlsConfig({
    required VoidCallback onClose,
  }) : super(
          overflowModalColor: AppTheme.mystic,
          overflowMenuCustomItems: [
            BetterPlayerOverflowMenuItem(
              Icons.close,
              'Закрыть видео',
              onClose,
            ),
          ],
        );
}

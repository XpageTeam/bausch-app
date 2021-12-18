import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:vimeoplayer_trinity/vimeoplayer_trinity.dart';
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
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
        //iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(top: 78),
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
      bottomButton: BottomButtonWithRoundedCorners(
        text: 'Перейти к просмотру',
        onPressed: () {
          Keys.mainNav.currentState!.pop();

          showDialog<void>(
            context: Keys.mainNav.currentContext!,
            builder: (context) => VimeoPopup(videoId: videoId),
          );
        },
      ),
    );
  }
}
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

class FinalWebinar extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  final List<String> videoIds;

  const FinalWebinar({
    required this.controller,
    required this.model,
    required this.videoIds,
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
                const Padding(
                  padding: EdgeInsets.only(top: 78),
                  child: Text(
                    'Ваш доступ к записи вебинара',
                    style: AppStyles.h1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
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
      bottomNavBar: BottomButtonWithRoundedCorners(
        text: 'Перейти к просмотру',
        onPressed: () {
          Keys.mainContentNav.currentState!.pop();

          showDialog<void>(
            context: context,
            builder: (context) => WebinarPopup(videoId: videoIds.first),
          );
        },
      ),
    );
  }
}

// class BauschControlsConfig extends BetterPlayerControlsConfiguration {
//   BauschControlsConfig({
//     required VoidCallback onClose,
//   }) : super(
//           overflowModalColor: AppTheme.mystic,
//           overflowMenuCustomItems: [
//             BetterPlayerOverflowMenuItem(
//               Icons.close,
//               'Закрыть видео',
//               onClose,
//             ),
//           ],
//         );
// }

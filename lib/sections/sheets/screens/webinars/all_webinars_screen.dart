import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
import 'package:flutter/material.dart';

//catalog_webinar
class AllWebinarsScreen extends StatefulWidget {
  final ScrollController controller;

  final AllWebinarsScreenArguments arguments;

  const AllWebinarsScreen({
    required this.controller,
    required this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebinarsScreenState();
}

class _WebinarsScreenState extends State<AllWebinarsScreen> {
  late final CatalogItemModel model;
  late final List<CatalogItemModel> webinars;

  @override
  void initState() {
    super.initState();

    model = widget.arguments.model;
    webinars = widget.arguments.webinars;
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
            bottom: 4,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                TopSection.webinar(
                  model,
                  widget.key,
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: model.previewText,
                  secondText: model.detailText,
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
            bottom: 40,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        CatalogItem(
                          model: webinars[i * 2],
                          onTap: () {
                            // TODO(Nikolay): Сделать запуск плеера.
                            final webinar = webinars[i * 2] as WebinarItemModel;
                            showDialog<void>(
                              context: context,
                              builder: (context) => WebinarPopup(
                                // TODO(Danil): массив id
                                videoId: webinar.videoIds.first,
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: webinars[i * 2].shield,
                        ),
                      ],
                    ),
                    if (webinars.asMap().containsKey(i * 2 + 1))
                      Stack(
                        children: [
                          CatalogItem(
                            model: webinars[i * 2 + 1],
                            onTap: () {
                              final webinar =
                                  webinars[i * 2 + 1] as WebinarItemModel;
                              showDialog<void>(
                                context: context,
                                builder: (context) => WebinarPopup(
                                  // TODO(Danil): массив id
                                  videoId: webinar.videoIds.first,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: webinars[i * 2 + 1].shield,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              childCount: (webinars.length % 2) == 0
                  ? webinars.length ~/ 2
                  : webinars.length ~/ 2 + 1,
            ),
          ),
        ),
      ],
    );
  }
}

class AllWebinarsScreenArguments extends ItemSheetScreenArguments {
  final CatalogItemModel model;
  final List<CatalogItemModel> webinars;

  AllWebinarsScreenArguments({required this.model, required this.webinars})
      : super(model: model);
}

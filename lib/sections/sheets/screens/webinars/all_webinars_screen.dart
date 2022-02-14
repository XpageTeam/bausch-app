import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/may_be_interesting_item.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_webinar
class AllWebinarsScreen extends CoreMwwmWidget<AllWebinarsScreenWM> {
  final ScrollController controller;

  AllWebinarsScreen({
    required this.controller,
    required ItemSheetScreenArguments arguments,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => AllWebinarsScreenWM(arguments),
        );

  @override
  WidgetState<CoreMwwmWidget<AllWebinarsScreenWM>, AllWebinarsScreenWM>
      createWidgetState() => _AllWebinarsScreenState();
}

class _AllWebinarsScreenState
    extends WidgetState<AllWebinarsScreen, AllWebinarsScreenWM> {
  // late final CatalogItemModel model;
  // late final List<CatalogItemModel> webinars;

  // @override
  // void initState() {
  //   super.initState();

  //   model = widget.arguments.model;
  // }

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
                  wm.catalogModel,
                  widget.key,
                  Image.asset(
                    'assets/play-video.png',
                    height: 28,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: wm.catalogModel.previewText,
                  secondText: wm.catalogModel.detailText,
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
          sliver: SliverToBoxAdapter(
            child: EntityStateBuilder<List<WebinarItemModel>>(
              streamedState: wm.webinarsStreamed,
              loadingChild: const Center(
                child: AnimatedLoader(),
              ),
              builder: (_, webinars) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    (webinars.length % 2) == 0
                        ? webinars.length ~/ 2
                        : webinars.length ~/ 2 + 1,
                    (i) => IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              CatalogItem(
                                model: webinars[i * 2],
                                onTap: () {
                                  // TODO(Nikolay): Сделать запуск плеера.
                                  final webinar = webinars[i * 2];
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
                                    final webinar = webinars[i * 2 + 1];
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      bottomNavBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: const [
          InfoBlock(),
        ],
      ),
    );
  }
}

class AllWebinarsScreenWM extends WidgetModel {
  final ItemSheetScreenArguments arguments;
  late final CatalogItemModel catalogModel = arguments.model;

  final webinarsStreamed = EntityStreamedState<List<WebinarItemModel>>();

  AllWebinarsScreenWM(this.arguments)
      : super(
          const WidgetModelDependencies(),
        ) {
    _loadWebinars();
  }

  Future<void> _loadWebinars() async {
    unawaited(webinarsStreamed.loading());

    CustomException? ex;

    try {
      final repository = await ProductsDownloader.load('promo_code_video');
      final webinars = repository.items
          .map((e) => e as WebinarItemModel)
          .where((webinar) => webinar.videoIds.length == 1)
          .toList();

      unawaited(webinarsStreamed.content(webinars));
    } on DioError catch (e) {
      ex = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: e.toString(),
        ex: e,
      );
    }

    if (ex != null) {
      // TODO(Nikolay): Доделать вывод ошибки.
    }
  }
}

// class AllWebinarsScreenArguments extends ItemSheetScreenArguments {
//   final List<CatalogItemModel> webinars;

//   AllWebinarsScreenArguments({
//     required CatalogItemModel model,
//     required this.webinars,
//   }) : super(model: model);
// }

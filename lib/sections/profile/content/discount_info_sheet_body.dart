import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/activate_lenses_sheet.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/simple_webview_widget.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountInfoSheetBodyArgs {
  final String title;
  final String? code;
  final String date;
  final String type;
  final int productId;
  final String? link;

  DiscountInfoSheetBodyArgs({
    required this.title,
    required this.date,
    required this.type,
    required this.productId,
    this.code,
    this.link,
  });
}

class DiscountInfoSheetBody extends StatefulWidget {
  final DiscountInfoSheetBodyArgs args;
  final ScrollController controller;

  const DiscountInfoSheetBody({
    required this.args,
    required this.controller,
    super.key,
  });

  @override
  State<DiscountInfoSheetBody> createState() => _DiscountInfoSheetBodyState();
}

class _DiscountInfoSheetBodyState extends State<DiscountInfoSheetBody> {
  final productModelEntity = EntityStreamedState<_ProductModel>()..loading();

  @override
  void initState() {
    super.initState();
    _loadProduct(widget.args.productId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: widget.controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 78,
                ),
                Text(
                  widget.args.title,
                  style: AppStyles.h1,
                ),
                const SizedBox(
                  height: 40,
                ),
                if (widget.args.code != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ContainerWithPromocode(
                      promocode: widget.args.code!,
                    ),
                  ),
                Text(
                  'Истечёт ${widget.args.date} года. Промокод хранится в личном кабинете. Введи его при оформлении товара в интернет-магазине',
                  style: AppStyles.p1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: EntityStateBuilder<_ProductModel>(
                    streamedState: productModelEntity,
                    // loadingChild: const AnimatedLoader(),
                    errorBuilder: (context, e) => SimpleErrorWidget(
                      title: 'Не удалось загрузить продукт',
                      buttonText: 'Повторить',
                      buttonCallback: () => _loadProduct(widget.args.productId),
                    ),
                    builder: (context, data) =>
                        WhiteContainerWithRoundedCorners(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.sidePadding,
                        vertical: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              data.title,
                              style: AppStyles.h2,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          ExtendedImage.network(
                            data.image,
                            loadStateChanged: onLoadStateChanged,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: ColoredBox(
        color: AppTheme.mystic,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                20,
                StaticData.sidePadding,
                8,
              ),
              child: BlueButton(
                onPressed: () {
                  if (widget.args.link != null) {
                    openSimpleWebView(context, url: widget.args.link!);
                  }
                },
                children: [
                  Text(
                    widget.args.type == 'offline'
                        ? 'Перейти на сайт оптики'
                        : 'Перейти в интернет-магазин',
                    style: AppStyles.h2,
                  ),
                  const SizedBox(width: 9),
                  Image.asset(
                    'assets/icons/link.png',
                    height: 15,
                  ),
                ],
              ),
            ),
            const ColoredBox(
              color: AppTheme.mystic,
              child: BottomInfoBlock(
                topPadding: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadProduct(int productId) async {
    unawaited(productModelEntity.loading());
    var hasError = false;
    try {
      final parsedData = BaseResponseRepository.fromMap(
        (await RequestHandler().get<Map<String, dynamic>>(
          'catalog/$productId/detail',
        ))
            .data!,
      );

      final product = _ProductModel.fromJson(
        parsedData.data as Map<String, dynamic>,
      );
      unawaited(productModelEntity.content(product));
    } on DioError catch (e) {
      hasError = true;
    } on ResponseParseException catch (e) {
      hasError = true;
    } on SuccessFalse catch (e) {
      hasError = true;
    }
    if (hasError) {
      unawaited(productModelEntity.error());
    }
  }
}

class _ProductModel {
  final int id;
  final String title;
  final String image;

  _ProductModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory _ProductModel.fromJson(Map<String, dynamic> map) {
    return _ProductModel(
      id: map['id'] as int,
      title: map['name'] as String,
      image: map['picture'] as String,
    );
  }
}

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/sections/shops/shops_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_discount_optics
class DiscountOpticsScreen extends CoreMwwmWidget<DiscountOpticsScreenWM>
    implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final PromoItemModel model;

  DiscountOpticsScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => DiscountOpticsScreenWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<DiscountOpticsScreenWM>, DiscountOpticsScreenWM>
      createWidgetState() => _DiscountOpticsScreenState();
}

class _DiscountOpticsScreenState
    extends WidgetState<DiscountOpticsScreen, DiscountOpticsScreenWM> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: widget.controller,
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
                    TopSection.product(
                      widget.model,
                      const DiscountInfo(text: 'Скидка 500 ₽ '),
                      widget.key,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(
                      text: widget.model.previewText,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                12,
                StaticData.sidePadding,
                40,
              ),
              sliver: LegalInfo(
                texts: [
                  'Перед заказом промокода на скидку необходимо проверить наличие продукта (на сайте и / или по контактному номеру телефона оптики).',
                  'Срок действия промокода и количество промокодов ограничены. ',
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
                //top: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      'Выбрать сеть оптик',
                      style: AppStyles.h1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 20,
                      ),
                      child: Text(
                        'Скидкой можно воспользоваться в любой из оптик сети.',
                        style: AppStyles.p1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              //TODO(Nikita): customCheckBox
              sliver: SliverToBoxAdapter(
                child: EntityStateBuilder<List<DiscountOptic>>(
                  streamedState: wm.discountOpticsStreamed,
                  builder: (_, discountOptics) => SelectShopSection(
                    discountOptics: discountOptics,
                    onChanged: wm.setCurrentOptic,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 10,
                      ),
                      child: WhiteButton(
                        text: 'Адреса оптик',
                        icon: Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                          ),
                          child: Image.asset(
                            'assets/icons/map-marker.png',
                            height: 16,
                          ),
                        ),
                        onPressed: () {
                          Keys.mainNav.currentState!
                              .push<void>(MaterialPageRoute(builder: (context) {
                            // TODO(Nikolay): Передавать список полученных оптик сюда.
                            return ShopsScreen();
                          }));
                        },
                      ),
                    ),
                    Warning.warning(),
                    const Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 20),
                      child: HowToUsePromocode(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: StreamedStateBuilder<DiscountOptic?>(
          streamedState: wm.currentDiscountOptic,
          builder: (_, currentOptic) {
            return CustomFloatingActionButton(
              text: wm.difference > 0
                  ? 'Нехватает ${wm.difference} б'
                  : 'Получить скидку',
              onPressed: currentOptic != null
                  ? () => wm.buttonAction()
                  : wm.difference > 0
                      ? () => wm.buttonAction()
                      : null,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class VerificationDiscountArguments extends SheetScreenArguments {
  final DiscountOptic discountOptic;

  VerificationDiscountArguments({
    required this.discountOptic,
    required CatalogItemModel model,
  }) : super(
          model: model,
        );
}

class DiscountOpticsScreenWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;

  final discountOpticsStreamed = EntityStreamedState<List<DiscountOptic>>();
  final currentDiscountOptic = StreamedState<DiscountOptic?>(null);
  final setCurrentOptic = StreamedAction<DiscountOptic>();

  final buttonAction = VoidAction();

  late int difference;

  DiscountOpticsScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        ) {
    _loadDiscountOptics();
  }

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;
    difference = itemModel.price - 10;
  }

  @override
  void onBind() {
    setCurrentOptic.bind(
      currentDiscountOptic.accept,
    );

    buttonAction.bind(
      (_) {
        if (difference > 0) {
          Keys.bottomSheetItemsNav.currentState!.pushNamed(
            '/add_points',
          );
        } else {
          Keys.bottomSheetItemsNav.currentState!.pushNamed(
            '/verification_discount_optics',
            arguments: VerificationDiscountArguments(
              model: itemModel,
              discountOptic: currentDiscountOptic.value!,
            ),
          );
        }
      },
    );
    super.onBind();
  }

  Future<void> _loadDiscountOptics() async {
    unawaited(discountOpticsStreamed.loading());

    try {
      final repository = await DiscountOpticsLoader.load(
        'offline',
        itemModel.code,
      );
      unawaited(discountOpticsStreamed.content(repository.discountOptics));
    } on DioError catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'При отправке запроса произошла ошибка',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'При чтении ответа от сервера произошла ошибка',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'Произошла ошибка',
            subtitle: e.toString(),
          ),
        ),
      );
    }
  }
}

class DiscountOpticsLoader {
  static Future<DiscountOpticsRepository> load(
    String category,
    String productCode,
  ) async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/order/available-optics/',
        queryParameters: <String, dynamic>{
          'category': 'offline',
          'productCode': productCode,
        },
        options: rh.cacheOptions
            ?.copyWith(
              maxStale: const Duration(days: 2),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );

    return DiscountOpticsRepository.fromList(res.data as List<dynamic>);
  }
}

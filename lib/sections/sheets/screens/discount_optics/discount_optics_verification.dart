import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsVerification
    extends CoreMwwmWidget<DiscountOpticsVerificationWM> {
  final ScrollController controller;

  DiscountOpticsVerification({
    required this.controller,
    required PromoItemModel model,
    required DiscountOptic discountOptic,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => DiscountOpticsVerificationWM(
            context: context,
            discountOptic: discountOptic,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<DiscountOpticsVerificationWM>,
          DiscountOpticsVerificationWM>
      createWidgetState() => _DiscountOpticsVerificationState();
}

class _DiscountOpticsVerificationState extends WidgetState<
    DiscountOpticsVerification, DiscountOpticsVerificationWM> {
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
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSliverAppbar.toPop(
                          icon: NormalIconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 20,
                            ),
                            onPressed: Navigator.of(context).pop,
                          ),
                          key: widget.key,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Подтвердите заказ',
                          style: AppStyles.h2,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'После подтверждения мы спишем баллы, и вы получите промокод',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DiscountInfo(text: 'Скидка 500 ₽'),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'в оптике ${wm.discountOptic.title}',
                              style: AppStyles.h2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BigCatalogItem(
                          model: wm.itemModel,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'После заказа у вас останется ${wm.remains} баллов',
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: StreamedStateBuilder<bool>(
          streamedState: wm.loadingState,
          builder: (_, isLoading) {
            return isLoading
                ? const CustomFloatingActionButton(
                    text: '',
                    icon: CircularProgressIndicator.adaptive(),
                  )
                : CustomFloatingActionButton(
                    text: 'Потратить ${wm.itemModel.price} б',
                    icon: Container(),
                    onPressed: wm.spendPointsAction,
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class DiscountOpticsVerificationWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;
  final DiscountOptic discountOptic;

  final loadingState = StreamedState<bool>(false);
  final spendPointsAction = VoidAction();

  late int points;
  late int remains;

  late UserWM userWm;

  DiscountOpticsVerificationWM({
    required this.context,
    required this.itemModel,
    required this.discountOptic,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    points = userWm.userData.value.data?.balance.available.toInt() ?? 0;

    remains = points - itemModel.price;

    super.onLoad();
  }

  @override
  void onBind() {
    spendPointsAction.bind(
      (_) => _spendPoints(),
    );

    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      await OrderDiscountSaver.save(
        discountOptic,
        itemModel,
      );

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWm.userData.content(userRepository);
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      _showTopError(error);
    } else {
      await Keys.bottomSheetItemsNav.currentState!.pushNamed(
        '/final_webinar',
        arguments: SheetScreenArguments(model: itemModel),
      );
    }
  }

  void _showTopError(CustomException ex) {
    showDefaultNotification(
      title: ex.title,
      subtitle: ex.subtitle,
    );
  }
}

class OrderDiscountSaver {
  static Future<BaseResponseRepository> save(
    DiscountOptic optic,
    PromoItemModel model,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.put<Map<String, dynamic>>(
      '/order/discount/save/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          'price': model.price,
          // 'addressId':optic.,
          // 'diopters':model.,
          // 'color':,
          // 'cylinder':,
          // 'axis':,
          'category': 'offline',
          'shopCode': optic.shopCode,
          'productCode': model.code,
        },
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    );

    final data = resp.data!;

    return BaseResponseRepository.fromMap(data);
  }
}

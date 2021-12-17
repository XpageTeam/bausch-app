import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
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
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PartnersVerification extends CoreMwwmWidget<PartnersVerificationWM> {
  final ScrollController controller;
  final PartnersItemModel model;

  PartnersVerification({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => PartnersVerificationWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  State<PartnersVerification> createState() => _PartnersVerificationState();

  @override
  WidgetState<PartnersVerification, PartnersVerificationWM>
      createWidgetState() => _PartnersVerificationState();
}

class _PartnersVerificationState
    extends WidgetState<PartnersVerification, PartnersVerificationWM> {
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, //Navigator.of(context).pop,
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              size: 20,
                              color: AppTheme.mineShaft,
                            ),
                          ),
                          key: widget.key,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Подтвердите заказ',
                          style: AppStyles.h1,
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
                        BigCatalogItem(
                          model: widget.model,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'После заказа у вас останется ${wm.rest.formatString} ${HelpFunctions.wordByCount(
                            wm.rest,
                            [
                              'баллов',
                              'балл',
                              'балла',
                            ],
                          )}',
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
        // bottomNavigationBar: CustomFloatingActionButton(
        //   text: 'Потратить ${widget.model.priceToString} б',
        //   withInfo: false,
        //   onPressed: wm.buttonAction,
        // ),

        bottomNavigationBar: StreamedStateBuilder<bool>(
          streamedState: wm.loadingState,
          builder: (_, isLoading) {
            return isLoading
                ? const CustomFloatingActionButton(
                    text: '',
                    icon: AnimatedLoader(),
                  )
                : CustomFloatingActionButton(
                    text: 'Потратить ${widget.model.price} б',
                    icon: Container(),
                    onPressed: wm.spendPointsAction,
                  );
          },
        ),
      ),
    );
  }
}

class PartnersVerificationWM extends WidgetModel {
  final BuildContext context;
  final PartnersItemModel itemModel;

  final loadingState = StreamedState<bool>(false);

  final spendPointsAction = VoidAction();

  int rest = 0;

  late UserWM userWm;

  PartnersVerificationWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );
  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    final points = userWm.userData.value.data?.balance.available.toInt() ?? 0;
    rest = points - itemModel.price;
    super.onLoad();
  }

  @override
  void onBind() {
    spendPointsAction.bind((_) => _spendPoints());
    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      final response = await OrderPartnerItemSaver.save(
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
      unawaited(
        Keys.bottomSheetItemsNav.currentState!.pushNamed(
          '/final_partners',
          arguments: SheetScreenArguments(
            model: itemModel,
          ),
        ),
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

class OrderPartnerItemSaver {
  static Future<BaseResponseRepository> save(PartnersItemModel model) async {
    final rh = RequestHandler();
    final response =
        BaseResponseRepository.fromMap((await rh.put<Map<String, dynamic>>(
      '/order/partner/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          // TODO(Nikolay): Изменить цену.
          'price': 1,
          'category': 'partner',
        },
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    ))
            .data!);

    return response;
  }
}

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/screens/parners/widget_models/partners_verification_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/text/remaining_points_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ConsultationVerification
    extends CoreMwwmWidget<ConsultationVerificationWM> {
  final ScrollController controller;

  ConsultationVerification({
    required this.controller,
    required ConsultationItemModel model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => ConsultationVerificationWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ConsultationVerificationWM>,
          ConsultationVerificationWM>
      createWidgetState() => _ConsultationVerificationState();
}

class _ConsultationVerificationState
    extends WidgetState<ConsultationVerification, ConsultationVerificationWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.mystic,
      controller: widget.controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
      ),
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
                    const SizedBox(
                      height: 78,
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
                      model: wm.itemModel,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    RemainingPointsText(
                      remains: wm.remains,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      bottomNavBar: StreamedStateBuilder<bool>(
        streamedState: wm.loadingState,
        builder: (_, isLoading) {
          return isLoading
              ? const CustomFloatingActionButton(
                  text: '',
                  icon: AnimatedLoader(),
                )
              : CustomFloatingActionButton(
                  text: 'Потратить ${wm.itemModel.price} б',
                  icon: Container(),
                  onPressed: wm.spendPointsAction,
                );
        },
      ),
      // bottomNavBar: CustomFloatingActionButton(
      //   text: 'Потратить ${model.price} б',
      //   onPressed: () {
      // Navigator.of(context).pushNamed(
      //   '/final_consultation',
      //   arguments: ItemSheetScreenArguments(model: model),
      // );
      //   },
      // ),
    );
  }
}

class ConsultationVerificationWM extends WidgetModel {
  final BuildContext context;
  final ConsultationItemModel itemModel;

  final loadingState = StreamedState<bool>(false);

  final spendPointsAction = VoidAction();

  int remains = 0;

  late UserWM userWm;
  ConsultationVerificationWM({
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
    remains = points - itemModel.price;
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
      await OrderPartnerItemSaver.save(
        itemModel,
        'consultation',
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
      showTopError(error);
    } else {
      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_consultation',
        (route) => route.isCurrent,
        arguments: ItemSheetScreenArguments(
          model: itemModel,
        ),
      );
    }
  }
}

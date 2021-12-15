import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/screens/webinars/widget_models/webinar_verification_wm.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class WebinarVerification extends CoreMwwmWidget<WebinarVerificationWM> {
  final ScrollController controller;
  final CatalogItemModel model;
  WebinarVerification({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => WebinarVerificationWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<WebinarVerificationWM>, WebinarVerificationWM>
      createWidgetState() => _WebinarVerificationState();
}

class _WebinarVerificationState
    extends WidgetState<WebinarVerification, WebinarVerificationWM> {
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          key: widget.key,
                          backgroundColor: Colors.white,
                          rightKey: Keys.mainNav,
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
                        BigCatalogItem(
                          model: widget.model,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (wm.remains >= 0)
                          Text(
                            'После заказа у вас останется ${wm.remains} ${HelpFunctions.wordByCount(
                              wm.remains,
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
        floatingActionButton: StreamedStateBuilder<bool>(
          streamedState: wm.loadingState,
          builder: (_, isLoading) {
            return isLoading
                ? const CustomFloatingActionButton(
                    text: '',
                    icon: CircularProgressIndicator.adaptive(),
                  )
                : CustomFloatingActionButton(
                    text: 'Потратить ${widget.model.price} б',
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

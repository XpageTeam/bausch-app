import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/screens/add_points/widget_models/add_points_details_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddPointsDetailsArguments {
  final AddPointsModel model;

  AddPointsDetailsArguments({required this.model});
}

//* Add_points
//* add
class AddPointsDetails extends CoreMwwmWidget<AddPointsDetailsWM>
    implements AddPointsDetailsArguments {
  @override
  final AddPointsModel model;
  final ScrollController controller;
  AddPointsDetails({
    required this.model,
    required this.controller,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => AddPointsDetailsWM(
            context: context,
            addPointsModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<AddPointsDetailsWM>, AddPointsDetailsWM>
      createWidgetState() => _AddPointsDetailsState();
}

class _AddPointsDetailsState
    extends WidgetState<AddPointsDetails, AddPointsDetailsWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(AppTheme.mystic);
        }
      },
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            padding: const EdgeInsets.all(18),
            iconColor: color,
          );
        },
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //* Верхний контейнер
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 64,
                          ),
                          ExtendedImage.network(
                            wm.addPointsModel.detailModel.icon,
                            fit: BoxFit.cover,
                            height: 200,
                            printError: false,
                            loadStateChanged: loadStateChangedFunction,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: StaticData.sidePadding,
                            ),
                            child: Text(
                              wm.addPointsModel.detailModel.title,
                              style: AppStyles.h1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: ButtonContent(
                              price: '+${wm.addPointsModel.reward}',
                              textStyle: AppStyles.h1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: wm.addPointsModel.detailModel.description!,
                  secondText: '',
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    // if (wm.addPointsModel.type == 'vk')
                    //   const FocusButton(labelText: 'Привязать аккаунт'),
                    // const SizedBox(
                    //   height: 4,
                    // ),
                    if (wm.addPointsModel.type == 'review' ||
                        wm.addPointsModel.type == 'review_social')
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: NativeTextInput(
                          labelText: 'Ссылка на отзыв',
                          controller: wm.linkController,
                        ),
                      ),
                    if (wm.addPointsModel.detailModel.btnName != null)
                      StreamedStateBuilder<bool>(
                        streamedState: wm.loadingState,
                        builder: (_, isLoading) {
                          return isLoading
                              ? const BlueButtonWithText(
                                  text: '',
                                  icon: UiCircleLoader(),
                                )
                              : StreamedStateBuilder<bool>(
                                  streamedState: wm.buttonEnabledState,
                                  builder: (_, enabled) {
                                    return BlueButtonWithText(
                                      text: wm
                                          .addPointsModel.detailModel.btnName!,
                                      onPressed: enabled
                                          ? () {
                                              wm.buttonAction();
                                            }
                                          : null,
                                      icon: wm.addPointsModel.detailModel
                                                  .btnIcon !=
                                              null
                                          ? ExtendedImage.network(
                                              wm.addPointsModel.detailModel
                                                  .btnIcon!,
                                              height: 15,
                                              printError: false,
                                              loadStateChanged:
                                                  loadStateChangedFunction,
                                            )
                                          : null,
                                    );
                                  },
                                );
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

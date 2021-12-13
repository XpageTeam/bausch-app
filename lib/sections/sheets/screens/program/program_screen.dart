import 'package:auto_size_text/auto_size_text.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/slider/indicator.dart';
import 'package:bausch/sections/home/widgets/slider/item_slider.dart';
import 'package:bausch/sections/profile/widgets/half_blured_circle.dart';
import 'package:bausch/sections/sheets/screens/program/program_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/appbar/appbar_for_bottom_sheet.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/custom_radio_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/text/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//Program
class ProgramScreen extends CoreMwwmWidget<ProgramScreenWM> {
  final ScrollController controller;
  ProgramScreen({
    required this.controller,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => ProgramScreenWM(),
        );

  @override
  WidgetState<CoreMwwmWidget<ProgramScreenWM>, ProgramScreenWM>
      createWidgetState() => _ProgramScreenState();
}

class _ProgramScreenState extends WidgetState<ProgramScreen, ProgramScreenWM> {
  TextEditingController nameController = TextEditingController();
  int gValue = 0;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<PrimaryData>(
      streamedState: wm.primaryDataStreamed,
      builder: (context, primaryData) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(5),
          ),
          child: Scaffold(
            backgroundColor: AppTheme.mystic,
            resizeToAvoidBottomInset: true,
            appBar: const AppBarForBottomSheet(),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                5,
                StaticData.sidePadding,
                0,
              ),
              child: CustomScrollView(
                controller: widget.controller,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Stack(
                              children: [
                                _HeaderContainer(
                                  text: primaryData.title,
                                ),
                                CustomSliverAppbar.toClose(
                                  Container(),
                                  widget.key,
                                ),
                              ],
                            ),
                          ),
                          _InfoBlock(
                            isWhiteContainerOnBackground: true,
                            content: Text(
                              primaryData.description,
                              style: AppStyles.p1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _InfoBlock(
                        headerText: 'В программе участвуют',
                        content: ItemSlider<Product>(
                          items: primaryData.products,
                          itemBuilder: (context, product) => _ProductItem(
                            product: product,
                          ),
                          indicatorBuilder: (context, isActive) => Indicator(
                            isActive: isActive,
                            animationDuration:
                                const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _InfoBlock(
                        isWhiteContainerOnBackground: true,
                        headerText: 'Важно знать перед подбором',
                        content: BulletedList(
                          list: primaryData.importantToKnow,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _InfoBlock(
                        headerText: 'Ваши данные',
                        content: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: NativeTextInput(
                                labelText: 'Имя',
                                controller: nameController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: NativeTextInput(
                                labelText: 'Фамилия',
                                controller: nameController,
                              ),
                            ),
                            NativeTextInput(
                              labelText: 'E-mail',
                              controller: nameController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _InfoBlock(
                        headerText: 'Чем пользуетесь для коррекции зрения',
                        content: Column(
                          children: List.generate(
                            primaryData.whatDoYouUse.length,
                            (i) => Padding(
                              padding: EdgeInsets.only(
                                bottom: i != primaryData.whatDoYouUse.length - 1
                                    ? 4
                                    : 0,
                              ),
                              child: CustomRadioButton(
                                text: primaryData.whatDoYouUse[i],
                                onPressed: () => debugPrint(
                                  primaryData.whatDoYouUse[i],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: WhiteButton(
                        text: 'Выбрать оптику',
                        icon: Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            top: 10,
                            bottom: 12,
                          ),
                          child: Image.asset(
                            'assets/icons/map-marker.png',
                            height: 16,
                          ),
                        ),
                        onPressed: () {
                          Keys.mainNav.currentState!.pop();
                          Keys.mainContentNav.currentState!.pushNamed('/shops');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                  ),
                  child: BlueButtonWithText(
                    text: 'Получить сертификат',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 60,
                  child: InfoBlock(),
                ),
                // Container(
                //   padding: const EdgeInsets.only(
                //     top: 8,
                //     bottom: 19,
                //   ),
                //   //height: 60,
                //   color: AppTheme.mystic,
                //   child: const InfoBlock(),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderContainer extends StatelessWidget {
  final String text;
  const _HeaderContainer({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              bottom: 33,
            ),
            // TODO(Nikolay): доделать.
            child: const HalfBluredCircle(
              text: 'X2',
              textStyle: TextStyle(
                fontSize: 25,
                height: 1,
                fontWeight: FontWeight.w600,
                color: AppTheme.mineShaft,
              ),
            ),
          ),
          AutoSizeText(
            text,
            style: AppStyles.h1,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        12,
        27,
        12,
        31,
      ),
      color: AppTheme.sulu,
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  const _ProductItem({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      padding: const EdgeInsets.fromLTRB(
        10,
        12,
        10,
        16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image.network(
              product.picture,
              height: 100,
              width: 100,
            ),
          ),
          Flexible(
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String? headerText;
  final Widget content;
  final bool isWhiteContainerOnBackground;
  const _InfoBlock({
    required this.content,
    this.isWhiteContainerOnBackground = false,
    this.headerText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (headerText != null)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                headerText!,
                style: AppStyles.h1,
              ),
            ),
          ),
        if (isWhiteContainerOnBackground) ...[
          WhiteContainerWithRoundedCorners(
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              20,
              StaticData.sidePadding,
              40,
            ),
            child: content,
          ),
        ] else ...[
          content,
        ],
      ],
    );
  }
}

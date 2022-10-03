import 'package:auto_size_text/auto_size_text.dart';
import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/profile/widgets/half_blured_circle.dart';
import 'package:bausch/sections/select_optic/select_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/program/widget_model/program_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/custom_radio_button.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:bausch/widgets/text/bulleted_list.dart';
import 'package:extended_image/extended_image.dart';
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
          widgetModelBuilder: (context) => ProgramScreenWM(
            context: context,
          ),
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
  void initState() {
    AppsflyerSingleton.sdk.logEvent('programmScreen', null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<PrimaryData>(
      streamedState: wm.primaryDataStreamed,
      loadingChild: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.mystic,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5),
          ),
        ),
        child: Center(
          child: AnimatedLoader(),
        ),
      ),
      errorBuilder: (context, e) {
        e as CustomException;

        return ErrorPage(
          title: e.title,
          // subtitle: e.subtitle,
          buttonText: 'Обновить',
          buttonCallback: wm.onLoad,
        );
      },
      builder: (context, primaryData) {
        return CustomSheetScaffold(
          controller: widget.controller,
          onScrolled: (offset) {
            if (offset > 60) {
              wm.colorState.accept(AppTheme.turquoiseBlue);
            } else {
              wm.colorState.accept(Colors.white);
            }
          },
          //resizeToAvoidBottomInset: false,
          hideBottomNavBarThenKeyboard: true,
          appBar: StreamedStateBuilder<Color>(
            streamedState: wm.colorState,
            builder: (_, color) {
              return CustomSliverAppbar(
                padding: const EdgeInsets.all(18),
                icon: Container(),
                iconColor: color,
              );
            },
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                StaticData.sidePadding,
                StaticData.sidePadding,
                40.0,
              ),
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
                          // CustomSliverAppbar(
                          //   key: widget.key,
                          // ),
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
            if (primaryData.products.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  StaticData.sidePadding,
                  0,
                  StaticData.sidePadding,
                  40.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: _InfoBlock(
                    headerText: 'В программе участвуют',
                    content: GestureDetector(
                      onTap: () {
                        AppsflyerSingleton.sdk
                            .logEvent('programmShowItem', null);
                      },
                      child: SimpleSlider<Product>(
                        items: primaryData.products,
                        builder: (context, product) => _ProductItem(
                          product: product,
                        ),
                        // indicatorBuilder: (context, isActive) => Indicator(
                        //   isActive: isActive,
                        //   animationDuration: const Duration(milliseconds: 300),
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                40.0,
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
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                40.0,
              ),
              sliver: SliverToBoxAdapter(
                child: _InfoBlock(
                  headerText: 'Ваши данные',
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: NativeTextInput(
                          labelText: 'Имя',
                          controller: wm.firstNameController,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: NativeTextInput(
                          labelText: 'Фамилия',
                          controller: wm.lastNameController,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      NativeTextInput(
                        labelText: 'E-mail',
                        controller: wm.emailController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                40.0,
              ),
              sliver: SliverToBoxAdapter(
                child: _InfoBlock(
                  headerText: 'Чем пользуетесь для коррекции зрения',
                  content: Column(
                    children: List.generate(
                      primaryData.whatDoYouUse.length,
                      (i) => Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              i != primaryData.whatDoYouUse.length - 1 ? 4 : 0,
                        ),
                        child: StreamedStateBuilder<int>(
                          streamedState: wm.whatDoYouUseIndex,
                          builder: (_, index) {
                            return CustomRadioButton(
                              text: primaryData.whatDoYouUse[i],
                              value: i,
                              selected: index == i,
                              onChanged: (value) {
                                wm.whatDoYouUseIndex.accept(i);
                                wm.whatDoYouUse
                                    .accept(primaryData.whatDoYouUse[i]);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                40.0,
              ),
              sliver: SliverToBoxAdapter(
                child: StreamedStateBuilder<Optic?>(
                  streamedState: wm.currentOpticStreamed,
                  builder: (_, currentOptic) => WhiteButton(
                    text: currentOptic == null
                        ? 'Выбрать оптику'
                        : wm.fullAddress,
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
                      AppsflyerSingleton.sdk
                          .logEvent('programmShowOpticsMap', null);
                      Keys.mainNav.currentState!.push<void>(
                        MaterialPageRoute(
                          builder: (context) {
                            // debugPrint('city: ${wm.city}');
                            return SelectOpticScreen(
                              initialCity: wm.city,
                              selectButtonText: 'Выбрать оптику',
                              onOpticSelect: (optic, city, shop) {
                                wm.city = city;

                                if (shop != null) {
                                  wm.selectOptic(optic.copyWith(shops: [shop]));
                                } else {
                                  wm.selectOptic(optic);
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          bottomNavBar: StreamedStateBuilder<Optic?>(
            streamedState: wm.currentOpticStreamed,
            builder: (_, currentOptic) => StreamedStateBuilder<bool>(
              streamedState: wm.loadingStreamed,
              builder: (_, loading) => CustomFloatingActionButton(
                text: loading ? '' : 'Получить сертификат',
                icon: loading ? const UiCircleLoader() : null,
                onPressed: currentOptic != null
                    ? loading
                        ? null
                        : () => wm.getCertificateAction()
                    : null,
              ),
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
      padding: const EdgeInsets.fromLTRB(12, 27, 12, 31),
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
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ExtendedImage.network(
              product.picture,
              height: 100,
              width: 100,
              printError: false,
              loadStateChanged: loadStateChangedFunction,
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

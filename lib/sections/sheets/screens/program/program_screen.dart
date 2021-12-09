import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/program/primary_data_downloader.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/shops/shops_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//Program
class ProgramScreen extends CoreMwwmWidget<ProgramScreenWM> {
  final ScrollController controller;
  ProgramScreen({required this.controller, Key? key})
      : super(
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          child: Scaffold(
            backgroundColor: AppTheme.mystic,
            resizeToAvoidBottomInset: true,
            body: CustomScrollView(
              controller: widget.controller,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: StaticData.sidePadding,
                    left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Stack(
                          children: [
                            Image.asset('assets/program.png'),
                            CustomSliverAppbar.toClose(Container(), widget.key),
                            // TODO(Nikolay): Название.
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        InfoSection(
                          secondText: primaryData.description,
                        ),
                        // TODO(Nikolay): В программе участвуют.
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 40,
                          ),
                          child: MayBeInteresting(),
                        ),
                        // TODO(Nikolay): Важно знать перед подбором.
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 40,
                          ),
                          child: InfoSection(
                            text: 'Важно знать перед подбором',
                            secondText: primaryData.description,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // TODO(Nikolay): Ваши данные будут браться из пользователя.
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                    bottom: 40,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Text(
                            'Ваши данные',
                            style: AppStyles.h1,
                          ),
                        ),
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
                // TODO(Nikolay): Чем пользуетесь для коррекции зрения.
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                    bottom: 30,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) =>
                          // TODO(Nikolay): Вынести в отдельный виджет.
                          Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              i != primaryData.whatDoYouUse.length - 1 ? 4 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   gValue = index;
                            // });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: StaticData.sidePadding,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    primaryData.whatDoYouUse[i],
                                    style: AppStyles.h3,
                                    maxLines: 3,
                                  ),
                                ),
                                CustomRadio(
                                  value: i,
                                  groupValue: gValue,
                                  onChanged: (v) {
                                    // setState(
                                    //   () {
                                    //     gValue = index;
                                    //   },
                                    // );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      childCount: primaryData.whatDoYouUse.length,
                    ),
                  ),
                ),

                // Выбрать оптику
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: WhiteButton(
                      text: 'Выбрать оптику',
                      icon: Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                        ),
                        child: Image.asset(
                          'assets/icons/map-marker.png',
                          height: 16,
                        ),
                      ),
                      onPressed: () =>
                          Keys.mainNav.currentState!.pushNamed('/shops'),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const InfoBlock(),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}

class ProgramScreenWM extends WidgetModel {
  final primaryDataStreamed = EntityStreamedState<PrimaryData>();

  ProgramScreenWM()
      : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _loadData();
    super.onLoad();
  }

  Future<void> _loadData() async {
    unawaited(primaryDataStreamed.loading());

    try {
      final data = await PrimaryDataDownloader.load();

      unawaited(primaryDataStreamed.content(data));
    } on DioError catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    }
  }
}

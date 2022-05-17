// ignore_for_file: prefer_mixin

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/repositories/offers/offers_repository.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/sections/profile_status_section.dart';
import 'package:bausch/sections/home/sections/scores_section.dart';
import 'package:bausch/sections/home/sections/spend_scores_section.dart';
import 'package:bausch/sections/home/sections/text_buttons_section.dart';
import 'package:bausch/sections/home/widgets/stories/stories_slider.dart';
import 'package:bausch/sections/home/wm/main_screen_wm.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:bausch/widgets/offers/offers_section_wm.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

///! место для костылей
OffersSectionWM? bannersWm;

class HomeScreen extends CoreMwwmWidget<MainScreenWM> {
  HomeScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) {
            return MainScreenWM(context: context);
          },
        );

  @override
  _HomeScreenState createWidgetState() => _HomeScreenState();
}

class _HomeScreenState extends WidgetState<HomeScreen, MainScreenWM>
    with WidgetsBindingObserver {
  double bottomHeigth = 0.0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    wm.changeAppLifecycleStateAction(state);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: const NewEmptyAppBar(
        scaffoldBgColor: AppTheme.mystic,
      ),
      body: SafeArea(
        child: EntityStateBuilder<bool>(
          streamedState: wm.allDataLoadedState,
          loadingChild: const Center(
            child: AnimatedLoader(),
          ),
          errorBuilder: (context, e) {
            e as CustomException;

            return ErrorPage(
              title: e.title,
              subtitle: e.subtitle,
              buttonText: 'Обновить',
              buttonCallback: wm.loadAllDataAction,
            );
          },
          builder: (_, allDataState) {
            return StreamedStateBuilder<AuthStatus>(
              streamedState: wm.authWM.authStatus,
              builder: (_, status) {
                return PullToRefreshNotification(
                  refreshOffset: 60,
                  maxDragOffset: 80,
                  color: Colors.black,
                  onRefresh: wm.homeScreenRefresh,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // SliverToBoxAdapter(
                      //   child: TextButton(
                      //     onPressed: () {
                      //       FirebaseAnalytics.instance.logEvent(
                      //         name: 'partner_order',
                      //         parameters: <String, dynamic>{
                      //           'partner_name_parameter': 'Test name 2',
                      //           // 'partner_name_parameter': 'Test name',
                      //         },
                      //       );
                      //     },
                      //     child: const Text('test firebase'),
                      //   ),
                      // ),
                      PullToRefreshContainer((info) {
                        return SliverList(
                          delegate: SliverChildListDelegate([
                            ClipRect(
                              child: SizedBox(
                                height: info?.dragOffset ?? 0,
                                child: const Center(
                                  child: AnimatedLoader(),
                                ),
                              ),
                            ),
                          ]),
                        );
                      }),
                      if (status == AuthStatus.authenticated)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: StaticData.sidePadding,
                            vertical: 14,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                const DelayedAnimatedTranslateOpacity(
                                  offsetY: 20,
                                  child: ProfileStatus(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (status == AuthStatus.authenticated)
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                            left: StaticData.sidePadding,
                            right: StaticData.sidePadding,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                EntityStateBuilder<UserRepository>(
                                  streamedState: wm.userWM.userData,
                                  builder: (_, data) {
                                    if (data.balance.nearestExpiration
                                            ?.amount !=
                                        null) {
                                      return const DelayedAnimatedTranslateOpacity(
                                        offsetY: 30,
                                        child: ScoresSection(
                                          loadingAnimationDuration: Duration(
                                            milliseconds: 2500,
                                          ),
                                          delay: Duration(
                                            milliseconds: 1000,
                                          ),
                                        ),
                                      );
                                    }

                                    return const SizedBox();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (status == AuthStatus.authenticated)
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                DelayedAnimatedTranslateOpacity(
                                  offsetY: 40,
                                  child: EntityStateBuilder<List<StoryModel>>(
                                    streamedState: wm.storiesList,
                                    loadingBuilder: (_, items) {
                                      if (items != null) {
                                        return StoriesSlider(items: items);
                                      }

                                      return const SizedBox();
                                    },
                                    builder: (_, items) {
                                      return StoriesSlider(items: items);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            DelayedAnimatedTranslateOpacity(
                              offsetY: 50,
                              child: EntityStateBuilder<OffersRepository>(
                                streamedState: wm.banners,
                                loadingBuilder: (context, repo) {
                                  if (repo != null) {
                                    return OffersSection(
                                      repo: repo,
                                      mainScreenWM: wm,
                                      margin: const EdgeInsets.only(
                                        bottom: 20,
                                        left: StaticData.sidePadding,
                                        right: StaticData.sidePadding,
                                      ),
                                      type: OfferType.homeScreen,
                                    );
                                  }

                                  return const SizedBox();
                                },
                                builder: (_, repo) {
                                  if (repo.offerList.isNotEmpty) {
                                    return OffersSection(
                                      repo: repo,
                                      mainScreenWM: wm,
                                      margin: const EdgeInsets.only(
                                        bottom: 20,
                                        left: StaticData.sidePadding,
                                        right: StaticData.sidePadding,
                                      ),
                                      type: OfferType.homeScreen,
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                              //  OfferWidget(),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        key: spendPointsPositionKey,
                        padding: const EdgeInsets.only(
                          left: StaticData.sidePadding,
                          right: StaticData.sidePadding,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              //* Потратить баллы, тут кнопки для вывода bottomSheet'ов
                              DelayedAnimatedTranslateOpacity(
                                offsetY: 60,
                                child: EntityStateBuilder<
                                    List<BaseCatalogSheetModel>>(
                                  streamedState: wm.catalog,
                                  loadingBuilder: (_, catalogItems) {
                                    if (catalogItems != null) {
                                      return SpendScores(
                                        catalogList: catalogItems,
                                      );
                                    }

                                    return const SizedBox();
                                  },
                                  builder: (_, catalogItems) {
                                    return SpendScores(
                                      catalogList: catalogItems,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: StaticData.sidePadding,
                          right: StaticData.sidePadding,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              //* Вам может быть интересно
                              StreamedStateBuilder<bool>(
                                streamedState: wm.mayBeInterestingState,
                                builder: (_, enabled) {
                                  return enabled
                                      ? MayBeInteresting(
                                          text: 'Вам может быть интересно',
                                        )
                                      : const SizedBox();
                                },
                              ),

                              //* Текстовые кнопки(Частые вопросы и тд)
                              const SizedBox(height: 40),
                              const TextButtonsSection(),
                              const SizedBox(
                                height: 100,
                              ),
                              Image.asset('assets/logo.png'),
                              SizedBox(
                                height: bottomHeigth,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: EntityStateBuilder<bool>(
        streamedState: wm.allDataLoadedState,
        builder: (_, allDataState) {
          if (allDataState) {
            return DelayedAnimatedTranslateOpacity(
              offsetY: 10,
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  bottomHeigth = constraints.minHeight + 10;
                  return CustomFloatingActionButton(
                    text: 'Добавить баллы',
                    icon: const Icon(
                      Icons.add,
                      color: AppTheme.mineShaft,
                    ),
                    onPressed: () {
                      showSheet<void>(
                        context,
                        SimpleSheetModel(
                          name: 'Добавить баллы',
                          type: 'add_points',
                        ),
                      );
                    },
                  );
                },
              ),
              animationDuration: Duration.zero,
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(),
            ],
          );
        },
      ),
    );
  }
}

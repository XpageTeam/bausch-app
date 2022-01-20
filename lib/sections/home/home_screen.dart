import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/sections/profile_status_section.dart';
import 'package:bausch/sections/home/sections/scores_section.dart';
import 'package:bausch/sections/home/sections/spend_scores_section.dart';
import 'package:bausch/sections/home/sections/text_buttons_section.dart';
import 'package:bausch/sections/home/widgets/stories/stories_slider.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/stories/cubit/stories_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:bausch/widgets/offers/offers_section_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

OffersSectionWM? bannersWm;
StoriesCubit? storiesCubitGlobal;

Future<void> voidFunction() async {
  return;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthWM authWM;
  late final UserWM userWM;

  double bottomHeigth = 0.0;

  @override
  void initState() {
    super.initState();
    authWM = Provider.of<AuthWM>(context, listen: false);
    userWM = Provider.of<UserWM>(context, listen: false);
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
        child: StreamedStateBuilder<AuthStatus>(
          streamedState: authWM.authStatus,
          builder: (_, status) {
            return PullToRefreshNotification(
              refreshOffset: 60,
              maxDragOffset: 80,
              color: Colors.black,
              onRefresh: () async {
                // await Future<void>.delayed(const Duration(seconds: 10));

                await Future.wait<void>([
                  userWM.reloadUserData(),
                  bannersWm?.loadData() ?? voidFunction(),
                  storiesCubitGlobal?.loadData() ?? voidFunction(),
                ]);

                // await bannersWm?.loadData();

                return true;
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  PullToRefreshContainer((info) {
                    return SliverList(
                      // backgroundColor: AppTheme.mystic,
                      // toolbarHeight: info?.dragOffset ?? 0,
                      // expandedHeight: info?.dragOffset,
                      // collapsedHeight: info?.dragOffset,
                      // title:

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
                          const [
                            DelayedAnimatedTranslateOpacity(
                              offsetY: 30,
                              child: ScoresSection(
                                loadingAnimationDuration: Duration(
                                  milliseconds: 2500,
                                ),
                                delay: Duration(
                                  milliseconds: 1000,
                                ),
                              ),
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
                            const DelayedAnimatedTranslateOpacity(
                              offsetY: 40,
                              child: StoriesSlider(),
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
                          child: OffersSection(
                            margin: const EdgeInsets.only(
                              bottom: 20,
                              left: StaticData.sidePadding,
                              right: StaticData.sidePadding,
                            ),
                            type: OfferType.homeScreen,
                          ),
                          //  OfferWidget(),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    key: spendPointsPositionKey,
                    padding: const EdgeInsets.only(
                      bottom: 40,
                      left: StaticData.sidePadding,
                      right: StaticData.sidePadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        const [
                          //* Потратить баллы, тут кнопки для вывода bottomSheet'ов
                          DelayedAnimatedTranslateOpacity(
                            offsetY: 60,
                            child: SpendScores(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 30,
                      left: StaticData.sidePadding,
                      right: StaticData.sidePadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          //* Вам может быть интересно
                          MayBeInteresting(
                            text: 'Вам может быть интересно',
                          ),

                          //* Текстовые кнопки(Частые вопросы и тд)
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
        ),
      ),
      bottomNavigationBar: DelayedAnimatedTranslateOpacity(
        offsetY: 10,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            bottomHeigth = constraints.minHeight;
            return CustomFloatingActionButton(
              text: 'Добавить баллы',
              icon: const Icon(
                Icons.add,
                color: AppTheme.mineShaft,
              ),
              onPressed: () {
                debugPrint(context.toString());
                showSheet<void>(
                  context,
                  SimpleSheetModel(name: 'Добавить баллы', type: 'add_points'),
                );
              },
            );
          },
        ),
        animationDuration: Duration.zero,
      ),
    );
  }
}

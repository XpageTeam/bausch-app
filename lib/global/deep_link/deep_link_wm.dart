import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/home/wm/main_screen_wm.dart';
import 'package:bausch/sections/my_lenses/choose_lenses/choose_lenses_screen.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/profile/profile_screen.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DeepLinkWM extends WidgetModel {
  final BuildContext context;
  final AuthWM authWM;

  // CatalogItemCubit catItemCubit;

  DeepLinkWM({
    required this.context,
    required this.authWM,
  }) : super(const WidgetModelDependencies()) {
    AppLinks().getInitialAppLinkString().then((val) {
      if (val != null) {
        authWM.subscribe(authWM.authStatus.stream, (status) {
          if (status == AuthStatus.authenticated) {
            onLink(val);
          }
        });
      }
    });
  }

  Future<void> onLink(String link) async {
    final uri = Uri.parse(link);

    final segments = uri.pathSegments;
    final params = uri.queryParameters;

    debugPrint(segments.toString());
    debugPrint(params.toString());

    if (segments.isEmpty ||
        authWM.authStatus.value != AuthStatus.authenticated) {
      return;
    }

    switch (segments[0]) {
      case 'program':
        await showSheet<void>(
          context,
          SimpleSheetModel(
            name: 'Программа подбора',
            type: 'program',
          ),
        );
        break;
      case 'profile_settings':
        await Keys.mainContentNav.currentState!.pushNamed('/profile_settings');
        break;
      case 'profile':
        await Keys.mainContentNav.currentState!.pushNamed(
          '/profile',
        );
        break;
      case 'faq':
        final faqCubit = FaqCubit();

        showLoader(context);
        await faqCubit.loadData();

        await goToFaq(faqCubit.state);

        break;
      case 'profile_notifications':
        await Keys.mainContentNav.currentState!.pushNamed(
          '/profile',
          arguments: const ProfileScreenArguments(showNotifications: true),
        );
        break;
      case 'stories':
        final mainScreenWM = MainScreenWM(context: context);

        showLoader(context);

        await mainScreenWM.loadStories();

        if (Keys.mainNav.currentState!.canPop()) {
          Keys.mainNav.currentState!.pop();
        }

        if ((mainScreenWM.storiesList.value.data?.isNotEmpty ?? false) &&
            params.containsKey('id')) {
          final storiesList = mainScreenWM.storiesList.value.data;

          StoryModel? targetStory;

          storiesList?.forEach((story) {
            if (story.id == int.tryParse(params['id']!)) {
              targetStory = story;
            }
          });

          if (targetStory != null) {
            unawaited(StoryWM.showStoryScreen(
              context: context,
              id: targetStory!.id,
              modelsList: storiesList!,
            ));
          }
        }

        break;

      case 'add_points':
        await goToPointsAdd();
        break;

      case 'catalog':
        if (!params.containsKey('type')) return;
        final cubit = CatalogItemCubit(section: params['type']!);

        showLoader(context);
        await cubit.loadData();

        await goToCatalog(cubit.state, params['type']!);
        break;

      case 'my_lenses':
        final myLensesWM = MyLensesWM();

        showLoader(context);

        await myLensesWM.loadAllData();

        if (Keys.mainNav.currentState!.canPop()) {
          Keys.mainNav.currentState!.pop();
        }

        if (myLensesWM.loadingInProgress.value == false) {
          if (myLensesWM.lensesPairModel.value != null) {
            await Keys.mainContentNav.currentState!.pushNamed(
              '/my_lenses',
              arguments: [myLensesWM],
            );
          } else {
            await Keys.mainContentNav.currentState!.pushNamed(
              '/choose_lenses',
              arguments: ChooseLensesScreenArguments(
                isEditing: false,
                myLensesWM: myLensesWM,
              ),
            );
          }
        }
        break;
    }
  }

  Future<void> goToStories(int id) async {
    // showSh
  }

  Future<void> goToFaq(FaqState state) async {
    if (state is FaqFailed) {
      if (Keys.mainNav.currentState!.canPop()) {
        Keys.mainNav.currentState!.pop();
      }

      showDefaultNotification(
        title: state.title,
        // subtitle: state.subtitle,
      );
    }

    if (state is FaqLoading) {
      showLoader(context);
    }

    if (state is FaqSuccess) {
      if (Keys.mainNav.currentState!.canPop()) {
        Keys.mainNav.currentState!.pop();

        await showSheet<List<TopicModel>>(
          context,
          SimpleSheetModel(
            name: 'Частые вопросы',
            type: 'faq',
          ),
          state.topics,
        );
      }
    }
  }

  Future<void> goToCatalog(CatalogItemState state, String catalogType) async {
    var title = 'Каталог';

    switch (catalogType) {
      case 'promo_code_video':
        title = 'Записи вебинаров';
        break;
      case 'promo_code_immediately':
        title = 'Предложения партнёров';
        break;

      case 'onlineShop100':
        title = 'Скидка 1000 рублей в интернет-магазине';
        break;

      case 'onlineShop':
        title = 'Скидка 500 рублей в интернет-магазине';
        break;

      case 'online200':
        title = 'Скидка 200 рублей на продукты для глаз';
        break;
    }

    if (state is CatalogItemFailed) {
      if (Keys.mainNav.currentState!.canPop()) {
        Keys.mainNav.currentState!.pop();
      }
      showDefaultNotification(
        title: state.title,
      );
    }

    if (state is CatalogItemLoading) {
      showLoader(context);
    }

    if (state is CatalogItemSuccess) {
      if (Keys.mainNav.currentState!.canPop()) {
        Keys.mainNav.currentState!.pop();
        await showSheet<List<CatalogItemModel>>(
          context,
          CatalogSheetModel(
            id: 0,
            type: catalogType,
            name: title,
            count: 4,
          ),
          state.items,
        );
      }
    }
  }

  Future<void> goToPointsAdd() async {
    await showSheet<void>(
      context,
      SimpleSheetModel(
        name: 'Накопить баллы',
        type: 'add_points',
      ),
    );
  }
}

Future<void> onLink(String link, BuildContext context) async {
  final uri = Uri.parse(link);

  final segments = uri.pathSegments;
  final params = uri.queryParameters;

  debugPrint(segments.toString());
  debugPrint(params.toString());

  // if (segments.isEmpty || authWM.authStatus.value != AuthStatus.authenticated) {
  //   return;
  // }

  switch (segments[0]) {
    case 'program':
      await showSheet<void>(
        context,
        SimpleSheetModel(
          name: 'Программа подбора',
          type: 'program',
        ),
      );
      break;
    case 'profile_settings':
      await Keys.mainContentNav.currentState!.pushNamed('/profile_settings');
      break;
    case 'profile':
      await Keys.mainContentNav.currentState!.pushNamed(
        '/profile',
      );
      break;
    case 'faq':
      final faqCubit = FaqCubit();

      showLoader(context);
      await faqCubit.loadData();

      // await goToFaq(faqCubit.state);

      break;
    case 'profile_notifications':
      await Keys.mainContentNav.currentState!.pushNamed(
        '/profile',
        arguments: const ProfileScreenArguments(showNotifications: true),
      );
      break;
    case 'stories':
      final mainScreenWM = MainScreenWM(context: context);

      showLoader(context);

      await mainScreenWM.loadStories();

      if (Keys.mainNav.currentState!.canPop()) {
        Keys.mainNav.currentState!.pop();
      }

      if ((mainScreenWM.storiesList.value.data?.isNotEmpty ?? false) &&
          params.containsKey('id')) {
        final storiesList = mainScreenWM.storiesList.value.data;

        StoryModel? targetStory;

        storiesList?.forEach((story) {
          if (story.id == int.tryParse(params['id']!)) {
            targetStory = story;
          }
        });

        if (targetStory != null) {
          unawaited(StoryWM.showStoryScreen(
            context: context,
            id: targetStory!.id,
            modelsList: storiesList!,
          ));
        }
      }

      break;

    case 'add_points':
      await goToPointsAdd(context);
      break;

    case 'catalog':
      if (!params.containsKey('type')) return;
      final cubit = CatalogItemCubit(section: params['type']!);

      showLoader(context);
      await cubit.loadData();

      // await goToCatalog(cubit.state, params['type']!);
      break;

    case 'my_lenses':
      final myLensesWM = MyLensesWM();

      showLoader(context);

      await myLensesWM.loadAllData();

      if (Keys.mainNav.currentState!.canPop()) {
        Keys.mainNav.currentState!.pop();
      }

      if (myLensesWM.loadingInProgress.value == false) {
        if (myLensesWM.lensesPairModel.value != null) {
          await Keys.mainContentNav.currentState!.pushNamed(
            '/my_lenses',
            arguments: [myLensesWM],
          );
        } else {
          await Keys.mainContentNav.currentState!.pushNamed(
            '/choose_lenses',
            arguments: ChooseLensesScreenArguments(
              isEditing: false,
              myLensesWM: myLensesWM,
            ),
          );
        }
      }
      break;
  }
}

Future<void> goToStories(int id) async {
  // showSh
}

Future<void> goToFaq(FaqState state, BuildContext context) async {
  if (state is FaqFailed) {
    if (Keys.mainNav.currentState!.canPop()) {
      Keys.mainNav.currentState!.pop();
    }

    showDefaultNotification(
      title: state.title,
      // subtitle: state.subtitle,
    );
  }

  if (state is FaqLoading) {
    showLoader(context);
  }

  if (state is FaqSuccess) {
    if (Keys.mainNav.currentState!.canPop()) {
      Keys.mainNav.currentState!.pop();

      await showSheet<List<TopicModel>>(
        context,
        SimpleSheetModel(
          name: 'Частые вопросы',
          type: 'faq',
        ),
        state.topics,
      );
    }
  }
}

Future<void> goToCatalog(CatalogItemState state, String catalogType, BuildContext context,) async {
  var title = 'Каталог';

  switch (catalogType) {
    case 'promo_code_video':
      title = 'Записи вебинаров';
      break;
    case 'promo_code_immediately':
      title = 'Предложения партнёров';
      break;

    case 'onlineShop100':
      title = 'Скидка 1000 рублей в интернет-магазине';
      break;

    case 'onlineShop':
      title = 'Скидка 500 рублей в интернет-магазине';
      break;

    case 'online200':
      title = 'Скидка 200 рублей на продукты для глаз';
      break;
  }

  if (state is CatalogItemFailed) {
    if (Keys.mainNav.currentState!.canPop()) {
      Keys.mainNav.currentState!.pop();
    }
    showDefaultNotification(
      title: state.title,
    );
  }

  if (state is CatalogItemLoading) {
    showLoader(context);
  }

  if (state is CatalogItemSuccess) {
    if (Keys.mainNav.currentState!.canPop()) {
      Keys.mainNav.currentState!.pop();
      await showSheet<List<CatalogItemModel>>(
        context,
        CatalogSheetModel(
          id: 0,
          type: catalogType,
          name: title,
          count: 4,
        ),
        state.items,
      );
    }
  }
}

Future<void> goToPointsAdd(BuildContext context) async {
  await showSheet<void>(
    context,
    SimpleSheetModel(
      name: 'Накопить баллы',
      type: 'add_points',
    ),
  );
}

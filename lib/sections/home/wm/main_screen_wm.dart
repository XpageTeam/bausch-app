// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/repositories/offers/offers_repository.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/home/requester/home_screen_requester.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MainScreenWM extends WidgetModel {
  final allDataLoadedState = EntityStreamedState<bool>();

  final storiesList = EntityStreamedState<List<StoryModel>>();
  final catalog = EntityStreamedState<List<BaseCatalogSheetModel>>();
  final banners = EntityStreamedState<OffersRepository>();

  final mayBeInterestingState = StreamedState<bool>(false);

  final loadDataAction = VoidAction();
  final loadCatalogAction = VoidAction();
  final loadBannersAction = VoidAction();
  final loadAllDataAction = VoidAction();

  final changeAppLifecycleStateAction = StreamedAction<AppLifecycleState>();

  final BuildContext context;
  final AuthWM authWM;
  final UserWM userWM;

  final _requester = HomeScreenRequester();

  bool canUpdate = true;

  late Timer? _reloadDataTimer;

  MainScreenWM({
    required this.context,
  })  : userWM = Provider.of<UserWM>(context, listen: false),
        authWM = Provider.of<AuthWM>(context, listen: false),
        super(const WidgetModelDependencies());

  @override
  void dispose() {
    _reloadDataTimer?.cancel();
    super.dispose();
  }

  @override
  void onBind() {
    super.onBind();
    if (userWM.userData.value.data!.balance.total > 0) {
      mayBeInterestingState.accept(true);
    }

    userWM.subscribe<EntityState<UserRepository>>(
      userWM.userData.stream,
      (value) {
        if (value.data != null) {
          if (value.data!.balance.total > 0) {
            mayBeInterestingState.accept(true);
          } else {
            mayBeInterestingState.accept(false);
          }
        }
      },
    );

    subscribe<AppLifecycleState>(
      changeAppLifecycleStateAction.stream,
      _changeAppLifecycleState,
    );

    loadCatalogAction.bind((_) {
      _loadCatalog();
    });

    loadAllDataAction.bind((_) {
      _loadAllData();
    });

    loadBannersAction.bind((_) {
      _loadBanners();
    });

    loadAllDataAction();

    _reloadDataTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        if (canUpdate) {
          homeScreenRefresh();
        }
      },
    );
  
  }

  /// Перезагружает данные
  /// [UserWM],
  Future<bool> homeScreenRefresh() async {
    await Future.wait<void>([
      userWM.reloadUserData(),
      // bannersWm?.loadData() ?? voidFunction(),
      _loadBanners(),
      _loadStories(),
      _loadCatalog(),
    ]);

    return true;
  }

  void _changeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        canUpdate = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        canUpdate = false;
        break;
    }
  }

  Future<void> _loadAllData() async {
    if (allDataLoadedState.value.isLoading) return;

    await allDataLoadedState.loading(allDataLoadedState.value.data);

    await Future.wait<void>([
      _loadStories(),
      _loadCatalog(),
      _loadBanners(),
    ]);

    if (catalog.value.error != null) {
      await allDataLoadedState.error(catalog.value.error);
      return;
    }

    await allDataLoadedState.content(true);
  }

  Future<void> _loadStories() async {
    if (storiesList.value.isLoading) return;

    // await storiesList.loading(storiesList.value.data);

    CustomException? error;

    try {
      final result = await _requester.loadStories();
      await storiesList.content([]);
      await storiesList.content(result);
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса приозошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При обработке ответа от сервера приозошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: e.toString(),
        ex: e,
      );
    } catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);
    }
  }

  Future<void> _loadCatalog() async {
    if (catalog.value.isLoading) return;

    await catalog.loading(catalog.value.data);

    try {
      await catalog.content(await _requester.loadCatalog());
    } on DioError catch (e) {
      await catalog.error(
        CustomException(
          title: 'При загрузке каталога произошла ошибка',
          subtitle: e.message,
          ex: e,
        ),
      );
    } on ResponseParseException catch (e) {
      await catalog.error(
        CustomException(
          title: 'При обработке ответа от сервера прозошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on SuccessFalse catch (e) {
      await catalog.error(
        CustomException(
          title: e.toString(),
          ex: e,
        ),
      );
    }
  }

  Future<void> _loadBanners() async {
    if (banners.value.isLoading) return;

    CustomException? error;

    try {
      final result = await OffersRepositoryDownloader.load(
        type: OfferType.homeScreen.asString,
      );
      await banners.content(OffersRepository(offerList: []));
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await banners.content(result);
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса приозошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При обработке ответа от сервера приозошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: e.toString(),
        ex: e,
      );
    } catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);

      await banners.content(
        banners.value.data ??
            OffersRepository(
              offerList: [],
            ),
      );
    }
  }
}

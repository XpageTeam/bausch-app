// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/offers/offers_repository.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/home/requester/home_screen_requester.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/stories/stories_screen.dart';
import 'package:bausch/static/static_data.dart';
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
  final String? dynamicLink;

  final _requester = HomeScreenRequester();

  bool canUpdate = true;
  List<StoryModel>? deepLinkStoriesList;

  late Timer? _reloadDataTimer;

  MainScreenWM({
    required this.context,
    this.dynamicLink,
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

  //* deepLinks
  Future<void> _loadFaq() async {
    CustomException? error;

    try {
      final rh = RequestHandler();

      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>('static/faq/')).data!,
      );

      final topics = (parsedData.data as List<dynamic>)
          .map((e) => TopicModel.fromMap(e as Map<String, dynamic>))
          .toList();
      debugPrint(topics.toString());

      // ignore: use_build_context_synchronously
      await showSheet<List<TopicModel>>(
        context,
        SimpleSheetModel(
          name: 'Частые вопросы',
          type: 'faq',
        ),
        topics,
      );
    } on Exception catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);
    }
  }

  //* deepLinks
  Future<void> _loadWebinars() async {
    CustomException? error;

    try {
      final rh = RequestHandler();

      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'catalog/products',
          queryParameters: <String, dynamic>{
            'section': StaticData.types['webinar'],
          },
        ))
            .data!,
      );
      final items = (parsedData.data as List<dynamic>)
          .map(
            // ignore: avoid_annotating_with_dynamic
            (dynamic item) =>
                WebinarItemModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();

      debugPrint(items.toString());

      // ignore: use_build_context_synchronously
      await showSheet<List<WebinarItemModel>>(
        context,
        SimpleSheetModel(
          name: 'Записи вебинаров',
          type: 'promo_code_video',
        ),
        items,
      );
    } on Exception catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);
    }
  }

  //* deepLinks
  Future<void> _loadDiscountOptics() async {
    CustomException? error;

    try {
      final rh = RequestHandler();

      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'catalog/products',
          queryParameters: <String, dynamic>{
            'section': StaticData.types['discount_optics'],
          },
        ))
            .data!,
      );
      final items = (parsedData.data as List<dynamic>)
          .map(
            // ignore: avoid_annotating_with_dynamic
            (dynamic item) =>
                PromoItemModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();

      debugPrint(items.toString());

      // ignore: use_build_context_synchronously
      await showSheet<List<PromoItemModel>>(
        context,
        SimpleSheetModel(
          name: 'Скидка 500 ₽ в оптике',
          type: 'discount_optics',
        ),
        items,
      );
    } on Exception catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);
    }
  }

  //* deepLinks
  Future<void> _loadDiscountOnline() async {
    CustomException? error;

    try {
      final rh = RequestHandler();

      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'catalog/products',
          queryParameters: <String, dynamic>{
            'section': StaticData.types['discount_online'],
          },
        ))
            .data!,
      );
      final items = (parsedData.data as List<dynamic>)
          .map(
            // ignore: avoid_annotating_with_dynamic
            (dynamic item) =>
                PromoItemModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();

      debugPrint(items.toString());

      // ignore: use_build_context_synchronously
      await showSheet<List<PromoItemModel>>(
        context,
        SimpleSheetModel(
          name: 'Скидка 500 ₽ в интернет-магазине',
          type: 'discount_online',
        ),
        items,
      );
    } on Exception catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);
    }
  }

//* deepLinks
  Future<void> _loadPartners() async {
    CustomException? error;

    try {
      final rh = RequestHandler();

      final parsedData = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          'catalog/products',
          queryParameters: <String, dynamic>{
            'section': StaticData.types['partners'],
          },
        ))
            .data!,
      );
      final items = (parsedData.data as List<dynamic>)
          .map(
            // ignore: avoid_annotating_with_dynamic
            (dynamic item) =>
                PartnersItemModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();

      debugPrint(items.toString());

      // ignore: use_build_context_synchronously
      await showSheet<List<PartnersItemModel>>(
        context,
        SimpleSheetModel(
          name: 'Предложения от партнеров',
          type: 'partners',
        ),
        items,
      );
    } on Exception catch (e) {
      error = CustomException(
        title: 'Поизошла ошибка',
        subtitle: e.toString(),
      );
    }

    if (error != null) {
      showDefaultNotification(title: error.title, subtitle: error.subtitle);
    }
  }

  Future<void> _pushStories() async {
    await Navigator.push<dynamic>(
      context,
      PageRouteBuilder<dynamic>(
        pageBuilder: (_, __, ___) {
          return StoriesScreen(
            // TODO(pavlov): в логах у истории выдается 7 id
            storyModel: 7,
            stories: deepLinkStoriesList!,
          );
        },
        barrierColor: Colors.black.withOpacity(0.8),
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(
            parent: animation,
            curve: Curves.fastLinearToSlowEaseIn,
          );
          return SlideTransition(
            position: Tween(
              begin: const Offset(0.0, 0.6),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _loadAllData() async {
    if (allDataLoadedState.value.isLoading) return;

    await allDataLoadedState.loading(allDataLoadedState.value.data);

    Future<void>? dynamicLinkFunction;
    var isStories = false;

    if (dynamicLink != null && dynamicLink != '/faq_form') {
      switch (dynamicLink) {
        case '/faq':
          dynamicLinkFunction = _loadFaq();
          break;
        case '/webinars':
          dynamicLinkFunction = _loadWebinars();
          break;
        case '/discount_optics':
          dynamicLinkFunction = _loadDiscountOptics();
          break;
        case '/discount_online':
          dynamicLinkFunction = _loadDiscountOnline();
          break;
        case '/partners':
          dynamicLinkFunction = _loadPartners();
          break;
        case '/stories':
          isStories = true;
          
          // dynamicLinkFunction = _loadFaq();
          break;
        default:
      
        // dynamicLinkFunction = _loadFaq();
      }
      await Future.wait<void>([
        _loadStories(),
        _loadCatalog(),
        _loadBanners(),
      ]);
      await Future.wait<void>([
        if (isStories)
          _pushStories()
        else if (dynamicLinkFunction != null)
          dynamicLinkFunction,
      ]);
    } else {
      await Future.wait<void>([
        _loadStories(),
        _loadCatalog(),
        _loadBanners(),
      ]);
    }
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
      deepLinkStoriesList = result;
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

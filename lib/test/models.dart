import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/models/sheets/folder/sheet_with_items_model.dart';
import 'package:bausch/models/sheets/folder/sheet_without_items_model.dart';
import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/static/static_data.dart';

class Models {
  static List<StoryModel> stories = [
    StoryModel(
      id: 0,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      content: StoryContentModel(
        file: 'assets/stories/1.png',
        title: 'Новинка  месяца',
      ),
      mainText: 'Новинка  месяца',
      secondText:
          'Зарегистрируйте чек и выиграйте путешествия мечты от ReNu. Всем участникам гарантированные призы!',
      buttonTitle: 'Участвовать в акции',
    ),
    StoryModel(
      id: 1,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      content: StoryContentModel(
        file: 'assets/stories/2.png',
        title: 'При трате баллов доставка день в день!',
      ),
      mainText: 'При трате баллов доставка день в день!',
      secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
      buttonTitle: 'Участвовать в акции',
    ),
    StoryModel(
      id: 2,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      content: StoryContentModel(
        file: 'assets/stories/3.png',
        title: 'С заботойо себе',
      ),
      mainText: 'С заботой о себе',
      secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
      buttonTitle: 'Участвовать в акции',
    ),
  ];

  static List<CatalogItemModel> items = [
    ProductItemModel(
      id: 0,
      name: '0. Раствор Biotrue универсальный(300 мл)',
      price: 1300,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
    ),
    WebinarItemModel(
      id: 1,
      name: '1. Раствор Biotrue универсальный(300 мл)',
      price: 1300,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
      vimeoId: '123',
    ),
    PartnersItemModel(
      id: 2,
      name: '2. Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
      poolPromoCode: '123',
      staticPromoCode: 'jij',
    ),
    ProductItemModel(
      id: 0,
      name: '0. Раствор Biotrue универсальный(300 мл)',
      price: 1300,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
    ),
    WebinarItemModel(
      id: 1,
      name: '1. Раствор Biotrue универсальный(300 мл)',
      price: 1300,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
      vimeoId: '123',
    ),
    PromoItemModel(
      id: 2,
      name: '2. Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
      code: '123',
    ),
  ];

  static List<CatalogItemModel> discountOptics = [
    ProductItemModel(
      id: 0,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 13000,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModel(
      id: 1,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/discountOptics/2.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModel(
      id: 2,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 600,
      picture: 'assets/discountOptics/3.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModel(
      id: 3,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 1300,
      picture: 'assets/discountOptics/4.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModel(
      id: 0,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 13000,
      picture: 'assets/discountOptics/1.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModel(
      id: 1,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/discountOptics/2.png',
      detailText: '',
      previewText: '',
    ),
  ];

  static List<CatalogItemModel> promo = [
    PromoItemModel(
      id: 0,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 13000,
      picture: 'assets/discountOptics/1.png',
      code: '6СС5165АDF345',
      previewText:
          'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
      detailText: '',
    ),
    PromoItemModel(
      id: 1,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/discountOptics/2.png',
      code: '6СС5165АDF345',
      previewText:
          'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
      detailText: '',
    ),
    PromoItemModel(
      id: 2,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 600,
      picture: 'assets/discountOptics/3.png',
      code: '6СС5165АDF345',
      previewText:
          'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
      detailText: '',
    ),
    PromoItemModel(
      id: 3,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 1300,
      picture: 'assets/discountOptics/4.png',
      code: '6СС5165АDF345',
      previewText:
          'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
      detailText: '',
    ),
    PromoItemModel(
      id: 0,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 13000,
      picture: 'assets/discountOptics/1.png',
      code: '6СС5165АDF345',
      previewText:
          'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
      detailText: '',
    ),
    PromoItemModel(
      id: 1,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/discountOptics/2.png',
      code: '6СС5165АDF345',
      previewText:
          'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
      detailText: '',
    ),
  ];

  static List<CatalogItemModel> partners = [
    PartnersItemModel(
      id: 1,
      name: 'Подписка на онлайн-кинотеатр ',
      previewText:
          'More.TV - онлайн-платформа, предлагающая возможности стриминга эфирного вещания, а также просмотра самого востребованного российского и зарубежного контента как бесплатно по рекламной модели, так и с помощью платной подписки.',
      detailText: 'detailText',
      picture: 'assets/partners/1.png',
      price: 50,
      poolPromoCode: '6СС5165АDF345',
      staticPromoCode: '6СС5165АDF345',
    ),
    PartnersItemModel(
      id: 1,
      name: 'Подписка на онлайн-библиотеку',
      previewText:
          'More.TV - онлайн-платформа, предлагающая возможности стриминга эфирного вещания, а также просмотра самого востребованного российского и зарубежного контента как бесплатно по рекламной модели, так и с помощью платной подписки.',
      detailText: 'detailText',
      picture: 'assets/partners/2.png',
      price: 50,
      poolPromoCode: '6СС5165АDF345',
      staticPromoCode: '6СС5165АDF345',
    ),
    PartnersItemModel(
      id: 1,
      name: 'Скидка 500 р. в интернет-оптике Inoptika',
      previewText:
          'More.TV - онлайн-платформа, предлагающая возможности стриминга эфирного вещания, а также просмотра самого востребованного российского и зарубежного контента как бесплатно по рекламной модели, так и с помощью платной подписки.',
      detailText: 'detailText',
      picture: 'assets/partners/3.png',
      price: 50,
      poolPromoCode: '6СС5165АDF345',
      staticPromoCode: '6СС5165АDF345',
    ),
    PartnersItemModel(
      id: 1,
      name: 'Скидка 500 р. в интернет-оптике NetOptika',
      previewText:
          'More.TV - онлайн-платформа, предлагающая возможности стриминга эфирного вещания, а также просмотра самого востребованного российского и зарубежного контента как бесплатно по рекламной модели, так и с помощью платной подписки.',
      detailText: 'detailText',
      picture: 'assets/partners/4.png',
      price: 50,
      poolPromoCode: '6СС5165АDF345',
      staticPromoCode: '6СС5165АDF345',
    ),
  ];

  static List<SheetModelWithItems> sheetsWithItems = [
    SheetModelWithItems(
      title: 'Скидка 500р в оптике',
      img: 'assets/discount-in-optics.png',
      models: items,
      type: SheetWithItemsType.discountOptics,
    ),
    SheetModelWithItems(
      title: 'Бесплатная упаковка',
      img: 'assets/free-packaging.png',
      models: items,
      type: SheetWithItemsType.packaging,
    ),
    SheetModelWithItems(
      title: 'Предложения от партнеров',
      img: 'assets/offers-from-partners.png',
      models: items,
      type: SheetWithItemsType.partners,
    ),
    SheetModelWithItems(
      title: 'Скидки в онлайн-магазинах',
      img: 'assets/discount-in-online-store.png',
      models: items,
      type: SheetWithItemsType.discountOnline,
    ),
    SheetModelWithItems(
      title: 'Записи вебинаров',
      img: 'assets/webinar-rec.png',
      models: items,
      type: SheetWithItemsType.webinar,
    ),
  ];

  static List<BaseCatalogSheetModel> sheets = [
    CatalogSheetWithLogosModel(
      id: 0,
      name: 'Скидка 500 рублей в оптике',
      type: 'offline',
      icon: 'assets/discount-in-optics.png',
      count: 3,
    ),
    CatalogSheetModel(
      id: 2,
      name: 'Предложения от партнеров',
      type: 'promo_code_immediately',
      icon: 'assets/offers-from-partners.png',
      count: 3,
    ),
    CatalogSheetModel(
      id: 2,
      name: 'Бесплатная упаковка',
      type: 'free_product',
      icon: 'assets/free-packaging.png',
      count: 3,
    ),
    CatalogSheetModel(
      id: 2,
      name: 'Скидка 500 рублей в интернет-магазине',
      type: 'onlineShop',
      icon: 'assets/discount-in-online-store.png',
      count: 3,
    ),
    CatalogSheetModel(
      id: 2,
      name: 'Записи вебинаров',
      type: 'promo_code_video',
      icon: 'assets/webinar-recordings.png',
      count: 3,
    ),
    CatalogSheetWithoutLogosModel(
      id: 1,
      name: 'Онлайн-консультация',
      type: 'online_consultation',
      icon: 'assets/online-consultations.png',
      count: 1,
    ),
  ];

  static List<AddItemModel> addItems = [
    AddItemModel(
      title: 'Подпишитесь на группу ВКонтакте',
      subtitle:
          'Подпишитесь на группу Bausch+Lomb Россия в социальной сети Вконтакте и получите 50 баллов.',
      price: '100',
      img: 'assets/add_points_vk.png',
      type: 'vk',
    ),
    AddItemModel(
      title: 'Пригласите друга',
      subtitle:
          'Пользуйтесь преимуществами программы лояльности вместе! Отправьте ссылку на регистрацию вашему другу и получите 100 баллов',
      price: '100',
      img: 'assets/add_points_vk.png',
      type: 'friend',
    ),
    AddItemModel(
      title: 'Написать отзыв в соцсетях',
      subtitle:
          'Опубликуйте отзыв c фотографией продукции Bausch+Lomb, пришлите нам подтверждение и получите дополнительные 100 баллов!',
      price: '100',
      img: 'assets/add_points_vk.png',
      type: 'overview_social',
    ),
    AddItemModel(
      title: 'Пройти опрос',
      subtitle:
          'Пройдите опрос от Bausch+Lomb! Мы начислим вам 100 дополнительных баллов.',
      price: '100',
      img: 'assets/add_points_vk.png',
      type: 'survey',
    ),
    AddItemModel(
      title: 'Напишите отзыв',
      subtitle:
          'Опубликуйте отзыв о продукции Bausch+Lomb или о преимуществах участия в Программе лояльности, пришлите нам подтверждение и получите дополнительные 50 баллов!',
      price: '50',
      img: 'assets/add_points_vk.png',
      type: 'overview',
    ),
    AddItemModel(
      title: 'Баллы в день рождения',
      subtitle:
          'В день Вашего рождения Вам будут начислены дополнительные баллы.',
      price: '50',
      img: 'assets/add_points_vk.png',
      type: 'birthday',
    ),
  ];

  static List<String> whatYouUse = [
    'Контактные линзы Bousch+Lomb ',
    'Контактные линзы других производителей',
    'Очки и контактные линзы Bousch+Lomb ',
    'Очки и контактные линзы других производителей',
    'Очки',
    'Ничем не пользуюсь',
  ];
}

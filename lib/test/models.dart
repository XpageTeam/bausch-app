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

class ProductItemModelSlider extends CatalogItemModel {
  ProductItemModelSlider({
    required int id,
    required String name,
    required String picture,
    required int price,
    required String detailText,
    required String previewText,
  }) : super(
          id: id,
          name: name,
          picture: picture,
          price: price,
          detailText: detailText,
          previewText: previewText,
        );
}

class Models {
  // static List<StoryModel> stories = [
  //   StoryModel(
  //     id: 0,
  //     // duration: Duration(seconds: 5),
  //     // media: MediaType.image,
  //     views: 1,
  //     content: [
  //       StoryContentModel(
  //         file: 'assets/pic1.png',
  //         title: 'Миллион впечатлений с ReNu',
  //       ),
  //     ],
  //     mainText: 'Миллион впечатлений с ReNu',
  //     secondText:
  //         'Зарегистрируйте чек и выиграйте путешествия мечты от ReNu. Всем участникам гарантированные призы!',
  //     buttonTitle: 'text one',
  //   ),
  //   StoryModel(
  //     id: 1,
  //     // duration: Duration(seconds: 5),
  //     // media: MediaType.image,
  //     views: 1,
  //     content: [
  //       StoryContentModel(
  //         file: 'assets/pic1.png',
  //         title: 'Прояви к глазам уважение',
  //       ),
  //     ],
  //     mainText: 'Прояви к глазам уважение',
  //     secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
  //     buttonTitle: 'text two',
  //   ),
  //   StoryModel(
  //     id: 2,
  //     // duration: Duration(seconds: 5),
  //     // media: MediaType.image,
  //     views: 1,
  //     content: [
  //       StoryContentModel(
  //         file: 'assets/pic3.png',
  //         title: 'ыаыаыыа',
  //       ),
  //     ],
  //     mainText: 'ыаыаыыа',
  //     secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
  //     buttonTitle: 'text three',
  //   ),
  // ];

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
      poolPromoCode: '6СС5165АDF345',
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
      picture: 'https://i.ibb.co/YtS92L4/1.png',
      detailText: '',
      previewText: '',
      code: '123',
    ),
  ];

  static List<CatalogItemModel> discountOptics = [
    ProductItemModelSlider(
      id: 0,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 13000,
      picture: 'https://i.ibb.co/YtS92L4/1.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModelSlider(
      id: 1,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'https://i.ibb.co/bg0j0NB/2.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModelSlider(
      id: 2,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 600,
      picture: 'https://i.ibb.co/Qvmj3z6/3.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModelSlider(
      id: 3,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 1300,
      picture: 'https://i.ibb.co/89NPJqb/4.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModelSlider(
      id: 0,
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: 13000,
      picture: 'https://i.ibb.co/YtS92L4/1.png',
      detailText: '',
      previewText: '',
    ),
    ProductItemModelSlider(
      id: 1,
      name: 'Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'https://i.ibb.co/bg0j0NB/2.png',
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

  static List<CatalogItemModel> webinars = [
    WebinarItemModel(
      id: 1,
      name: 'Контактная коррекция зрения в эпоху цифровизации ',
      previewText: '',
      detailText: 'detailText',
      picture: 'assets/woman.png',
      price: 50,
      vimeoId: '123',
    ),
    WebinarItemModel(
      id: 1,
      name: 'Контактная коррекция зрения в эпоху цифровизации ',
      previewText: '',
      detailText: 'detailText',
      picture: 'assets/woman.png',
      price: 50,
      vimeoId: '123',
    ),
    WebinarItemModel(
      id: 1,
      name: 'Контактная коррекция зрения в эпоху цифровизации ',
      previewText: '',
      detailText: 'detailText',
      picture: 'assets/woman.png',
      price: 50,
      vimeoId: '123',
    ),
    WebinarItemModel(
      id: 1,
      name: 'Контактная коррекция зрения в эпоху цифровизации ',
      previewText: '',
      detailText: 'detailText',
      picture: 'assets/woman.png',
      price: 50,
      vimeoId: '123',
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
      title: 'Предложения\nот партнеров',
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
      htmlText:
          '<p>Для начисления баллов за подписку на группу Bausch+Lomb в социальной сети «Вконтакте» необходимо:</p><br><ul><li>Привязать свой аккаунт в социальной сети «ВКонтакте» к профилю.</li><li>Перейти на станицу группы в социальной сети «ВКонтакте» и подписаться на неё.</li></ul><br><p>50 баллов будут начислены на счёт в течение 2 рабочих дней с момента выполнения всех действий.</p>',
      type: 'vk',
    ),
    AddItemModel(
      title: 'Пригласите друга',
      subtitle:
          'Пользуйтесь преимуществами программы лояльности вместе! Отправьте ссылку на регистрацию вашему другу и получите 100 баллов',
      price: '100',
      img: 'assets/add_points_friend.png',
      type: 'friend',
      htmlText:
          '<p>Баллы будут начислены в том случае, если ваш друг ранее еще не был зарегистрирован в программе лояльности <a href="#">Bausch+Lomb FRIENDS</a>. Начисление баллов произойдет, как только друг зарегистрирует свой первый код с упаковки.</p>',
    ),
    AddItemModel(
      title: 'Написать отзыв в соцсетях',
      subtitle:
          'Опубликуйте отзыв c фотографией продукции Bausch+Lomb, пришлите нам подтверждение и получите дополнительные 100 баллов!',
      price: '100',
      img: 'assets/add_points_reviev.png',
      type: 'overview_social',
      htmlText:
          '<p>Для начисления баллов за публикацию отзыва о Продукции в социальной сети необходимо:</p><br><ul><li>опубликовать в социальной сети «ВКонтакте», «Facebook», «Одноклассники», «Instagram» или «Tik-Tok» положительный, нейтральный или содержащий конструктивную критику отзыв объёмом не менее 15  слов;</li><li>в разделе «Накопить баллы» выбрать способ накопления «Написать отзыв в соцсетях», в открывшемся окне ввести ссылку и прикрепить скриншот;</li><li>отзыв должен быть опубликован не ранее, чем за 3 месяца до направления отзыва на проверку, и не ранее даты регистрации Участника в Программе.</li></ul><br><p>Если отзыв прошел модерацию, то в течение 30 рабочих дней на счет начисляются 100 баллов.</p>',
    ),
    AddItemModel(
      title: 'Напишите отзыв',
      subtitle:
          'Опубликуйте отзыв о продукции Bausch+Lomb или о преимуществах участия в Программе лояльности, пришлите нам подтверждение и получите дополнительные 50 баллов!',
      price: '50',
      img: 'assets/add_points_review2.png',
      type: 'overview',
      htmlText:
          '<p>Чтобы получить дополнительные баллы за публикацию отзыва о Продукции на указанных Интернет-ресурсах необходимо: </p><br><ul><li>опубликовать на любом Интернет-ресурсе из списка положительный, нейтральный или содержащий конструктивную критику отзыв объёмом не менее 15 слов и содержащий фото продукта; </li><li>в разделе «Накопить баллы» выбрать способ накопления «Написать отзыв», в открывшемся окне ввести ссылку и прикрепить скриншот; </li><li>отзыв должен быть опубликован не позднее, чем за 3 суток до направления отзыва на проверку, но не ранее, чем за 3 месяца до направления отзыва на проверку, и не ранее даты начала действия Программы. Модерация отзыва занимает до 30 рабочих дней. Затем 50 баллов начисляются на Счёт.</li></ul><br><p>Площадки, где вы можете разместить отзыв:</p><br><p><a href="#">irecommend.ru</a></p><p><a href="#">ru.otzyv.com</a></p><p><a href="#">otzovik.com</a></p><p><a href="#">otzyv-pro.ru</a></p><p><a href="#">spasibovsem.ru</a></p><p><a href="#">otzyvov.net</a></p><p><a href="#">market.yandex.ru</a></p><p><a href="#">Ozon.ru</a></p><p><a href="#">Goods.ru</a></p><p><a href="#">Beru.ru</a></p><p><a href="#">wildberries.ru</a></p>',
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
      title: 'Баллы в день рождения',
      subtitle:
          'В день Вашего рождения Вам будут начислены дополнительные баллы.',
      price: '50',
      img: 'assets/add_points_pool.png',
      type: 'birthday',
    ),
    AddItemModel(
      title: 'Двойные баллы',
      subtitle:
          'Получите двойные баллы при регистрации кода в течение 14 дней после подбора контактных линз.',
      price: '50',
      img: 'assets/add_points_vk.png',
      type: 'double',
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

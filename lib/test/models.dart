import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
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
        file: 'assets/pic1.png',
        title: 'Миллион впечатлений с ReNu',
      ),
      mainText: 'Миллион впечатлений с ReNu',
      secondText:
          'Зарегистрируйте чек и выиграйте путешествия мечты от ReNu. Всем участникам гарантированные призы!',
      buttonTitle: 'text one',
    ),
    StoryModel(
      id: 1,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      content: StoryContentModel(
        file: 'assets/pic1.png',
        title: 'Прояви к глазам уважение',
      ),
      mainText: 'Прояви к глазам уважение',
      secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
      buttonTitle: 'text two',
    ),
    StoryModel(
      id: 2,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      content: StoryContentModel(
        file: 'assets/pic3.png',
        title: 'ыаыаыыа',
      ),
      mainText: 'ыаыаыыа',
      secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
      buttonTitle: 'text three',
    ),
  ];

  static List<CatalogItemModel> items = [
    CatalogItemModel(
      id: 0,
      name: '0. Раствор жопы универсальный(300 мл)',
      price: 1300,
      picture: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      id: 1,
      name: '1. Раствор Biotrue универсальный(300 мл)',
      price: 1300,
      picture: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      id: 2,
      name: '2. Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      id: 3,
      name: '3. Раствор',
      price: 1300,
      picture: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      id: 4,
      name: '4. Раствор',
      price: 1300,
      picture: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      id: 5,
      name: '5. Раствор',
      price: 1300,
      picture: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      id: 6,
      name: '6. Раствор',
      price: 1300,
      picture: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      id: 7,
      name: '7. Biotrue one day (30 линз в упаковке)',
      price: 600,
      picture: 'assets/items/item2.png',
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

  static List<SheetModelWithoutItems> sheets = [
    SheetModelWithoutItems(
      title: 'Онлайн-консультация',
      img: 'assets/online-consultations.png',
      type: SheetWithoutItemsType.consultation,
    ),
    SheetModelWithoutItems(
      title: 'Бесплатно подберем вам первые линзы в оптике',
      img: 'assets/online-consultations.png',
      type: SheetWithoutItemsType.program,
    ),
    SheetModelWithoutItems(
      title: 'Добавить баллы',
      img: 'assets/online-consultations.png',
      type: SheetWithoutItemsType.addpoints,
    ),
  ];

  static List<AddItemModel> addItems = [
    AddItemModel(
      title: 'Подпишитесь на группу ВКонтакте',
      subtitle:
          'Подпишитесь на группу Bausch+Lomb Россия в социальной сети Вконтакте и получите 50 баллов.',
      price: '100',
      img: 'assets/add_points_vk.png',
    ),
  ];
}

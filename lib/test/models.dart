import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheets/folder/sheet_with_items_model.dart';
import 'package:bausch/models/sheets/folder/sheet_without_items_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/static/static_data.dart';

class Models {
  // static List<StoryModel> stories = [
  //   const StoryModel(
  //     index: 0,
  //     duration: Duration(seconds: 5),
  //     media: MediaType.image,
  //     url: 'assets/pic1.png',
  //     mainText: 'Миллион впечатлений с ReNu',
  //     secondText:
  //         'Зарегистрируйте чек и выиграйте путешествия мечты от ReNu. Всем участникам гарантированные призы!',
  //     buttonTitle: 'text one',
  //   ),
  // ];

  static List<CatalogItemModel> items = [
    CatalogItemModel(
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: 'Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: 'Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: 'Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: 'Раствор',
      price: '1300',
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

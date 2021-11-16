import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/models/sheets/sheet_without_items_model.dart';
import 'package:bausch/models/story_model.dart';
import 'package:bausch/static/static_data.dart';

class Models {
  static List<StoryModel> stories = [
    const StoryModel(
      index: 0,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      url: 'assets/pic1.png',
      mainText: 'Миллион впечатлений с ReNu',
      secondText:
          'Зарегистрируйте чек и выиграйте путешествия мечты от ReNu. Всем участникам гарантированные призы!',
      buttonTitle: 'text one',
    ),
    const StoryModel(
      index: 1,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      url: 'assets/pic1.png',
      mainText: 'Прояви к глазам уважение',
      secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
      buttonTitle: 'text two',
    ),
    const StoryModel(
      index: 2,
      duration: Duration(seconds: 5),
      media: MediaType.image,
      url: 'assets/pic3.png',
      mainText: 'ыаыаыыа',
      secondText: 'Выбирай Biotrue ONEday и выигрывай один из главных призов:!',
      buttonTitle: 'text three',
    ),
  ];

  static List<CatalogItemModel> items = [
    CatalogItemModel(
      name: '0. Раствор жопы универсальный(300 мл)',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '1. Раствор Biotrue универсальный(300 мл)',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '2. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: '3. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '4. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '5. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '6. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '7. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: '8. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '9. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '10. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '11. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '12. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: '13. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '14. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: '15. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '16. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '17. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '18. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '19. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: '20. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '21. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
    ),
    CatalogItemModel(
      name: '22. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '23. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
    ),
    CatalogItemModel(
      name: '24. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '25. Раствор',
      price: '1300',
    ),
    CatalogItemModel(
      name: '26. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
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

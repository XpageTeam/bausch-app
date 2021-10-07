import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/story_model.dart';

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
        name: 'Раствор Biotrue универсальный(300 мл)',
        price: '1300',
        img: 'assets/items/item1.png'),
    CatalogItemModel(
        name: 'Biotrue one day (30 линз в упаковке)',
        price: '600',
        img: 'assets/items/item2.png'),
    CatalogItemModel(
        name: 'Раствор', price: '1300', img: 'assets/items/item1.png'),
    CatalogItemModel(
        name: 'Раствор', price: '1300', img: 'assets/items/item1.png'),
    CatalogItemModel(
        name: 'Раствор', price: '1300', img: 'assets/items/item1.png'),
  ];
}

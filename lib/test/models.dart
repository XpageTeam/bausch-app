import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/story_model.dart';

class Models {
  static List<Story> stories = [
    Story(number: 3, title: 'Новинка месяца', img: 'assets/pic1.png'),
    Story(
        number: 8,
        title: 'При трате баллов доставка день в день!',
        img: 'assets/pic2.png'),
    Story(number: 6, title: 'С заботой о себе', img: 'assets/pic3.png'),
    Story(number: 6, title: 'С заботой о себе', img: 'assets/pic3.png'),
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

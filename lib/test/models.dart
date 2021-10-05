import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheet_model.dart';

class Models {
  static List<CatalogItemModel> items = [
    CatalogItemModel(
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: '1300',
    ),
    CatalogItemModel(
      name: 'Biotrue one day (30 линз в упаковке)',
      price: '600',
    ),
    CatalogItemModel(
      name: 'Biotrue one day (30 линз в упаковке)',
      price: '600',
    ),
    CatalogItemModel(
      name: 'b;ab;abab;aknn',
      price: '600',
    ),
    CatalogItemModel(
      name: 'Раствор',
      price: '1300',
    ),
  ];

  static List<SheetModel> sheets = [
    SheetModel(
      title: 'Бесплатная упаковка',
      img: 'assets/free-packaging.png',
      models: items,
    ),
    SheetModel(
      title: 'Предложения от партнеров',
      img: 'assets/offers-from-partners.png',
      models: items,
    ),
    SheetModel(
      title: 'Скидки в онлайн-магазинах',
      img: 'assets/discount-in-online-store.png',
      models: items,
    ),
    SheetModel(
      title: 'Записи вебинаров',
      img: 'assets/webinar-rec.png',
      models: items,
    ),
  ];
}

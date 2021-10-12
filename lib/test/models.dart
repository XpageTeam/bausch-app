import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/static/static_data.dart';

class Models {
  static List<CatalogItemModel> items = [
    CatalogItemModel(
      name: 'Раствор Biotrue универсальный(300 мл)',
      price: '1300',
      discount: '500',
      img: 'assets/free-packaging.png',
    ),
    CatalogItemModel(
      name: 'Biotrue one day (30 линз в упаковке)',
      price: '600',
      discount: '500',
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
      title: 'Скидка 500р в оптике',
      img: 'assets/discount-in-optics.png',
      models: items,
      type: SheetType.discountOptics,
    ),
    SheetModel(
      title: 'Бесплатная упаковка',
      img: 'assets/free-packaging.png',
      models: items,
      type: SheetType.packaging,
    ),
    SheetModel(
      title: 'Предложения от партнеров',
      img: 'assets/offers-from-partners.png',
      models: items,
      type: SheetType.partners,
    ),
    SheetModel(
      title: 'Скидки в онлайн-магазинах',
      img: 'assets/discount-in-online-store.png',
      models: items,
      type: SheetType.discountOnline,
    ),
    SheetModel(
      title: 'Записи вебинаров',
      img: 'assets/webinar-rec.png',
      models: items,
      type: SheetType.webinar,
    ),
    SheetModel(
      title: 'Онлайн консультации',
      models: items,
      type: SheetType.consultations,
    ),
  ];
}

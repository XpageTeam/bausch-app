import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/sheets/folder/sheet_without_items_model.dart';
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
      id: 2,
      name: 'name',
      previewText: 'previewText',
      detailText: 'detailText',
      picture:
          'https://icdn.lenta.ru/images/2019/12/06/10/20191206104306174/pwa_vertical_1280_4c9fd519bc66e04b4a6eb24307a025ad.jpg',
      price: 23,
    ),
    CatalogItemModel(
      id: 2,
      name: 'name',
      previewText: 'previewText',
      detailText: 'detailText',
      picture:
          'https://icdn.lenta.ru/images/2019/12/06/10/20191206104306174/pwa_vertical_1280_4c9fd519bc66e04b4a6eb24307a025ad.jpg',
      price: 23,
    ),
    CatalogItemModel(
      id: 2,
      name: 'name',
      previewText: 'previewText',
      detailText: 'detailText',
      picture:
          'https://icdn.lenta.ru/images/2019/12/06/10/20191206104306174/pwa_vertical_1280_4c9fd519bc66e04b4a6eb24307a025ad.jpg',
      price: 23,
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

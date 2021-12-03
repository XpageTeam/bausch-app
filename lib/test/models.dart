import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/models/sheets/sheet_without_items_model.dart';
import 'package:bausch/models/story_model.dart';
import 'package:bausch/models/survey_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/catalog_item/catalog_item_widget.dart';

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
      name: '1. Раствор Biotrue универсальный(300 мл)',
      price: '1300',
      img: 'assets/items/item1.png',
      address: 'Aдрес: г. Москва, ул. Задарожная, д. 20, к. 2 ',
      deliveryInfo: 'Ещё пару дней...',
    ),
    CatalogItemModel(
      name: '2. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
      address: 'Aдрес: г. Москва, ул. Задарожная, д. 20, к. 2 ',
      deliveryInfo: 'Ещё пару дней...',
    ),
    CatalogItemModel(
      name: '3. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
      type: ItemType.promocodeFollow,
    ),
    CatalogItemModel(
      name: '4. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
      address: 'Aдрес: г. Москва, ул. Задарожная, д. 20, к. 2 ',
      deliveryInfo: 'Ещё пару дней...',
    ),
    CatalogItemModel(
      name: '5. Раствор',
      price: '1300',
      type: ItemType.promocodeFollow,
    ),
    CatalogItemModel(
      name: '6. Раствор',
      price: '1300',
      type: ItemType.promocodeCopy,
    ),
    CatalogItemModel(
      name: '7. Biotrue one day (30 линз в упаковке)',
      price: '600',
      img: 'assets/items/item2.png',
      type: ItemType.webinar,
    ),
    CatalogItemModel(
      name: '8. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
      type: ItemType.webinar,
    ),
    CatalogItemModel(
      name: '9. Раствор',
      price: '1300',
      img: 'assets/items/item1.png',
      type: ItemType.webinar,
    ),
    CatalogItemModel(
      name: '10. Раствор',
      price: '1300',
      type: ItemType.webinar,
    ),
    CatalogItemModel(
      name: '11. Раствор',
      price: '1300',
      type: ItemType.webinar,
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
    AddItemModel(
      title: 'Пригласите друга',
      subtitle:
          'Пользуйтесь преимуществами программы лояльности вместе! Отправьте ссылку на регистрацию вашему другу и получите 100 баллов',
      price: '100',
      img: 'assets/add_points_vk.png',
    ),
    AddItemModel(
      title: 'Написать отзыв в соцсетях',
      subtitle:
          'Опубликуйте отзыв c фотографией продукции Bausch+Lomb, пришлите нам подтверждение и получите дополнительные 100 баллов!',
      price: '100',
      img: 'assets/add_points_vk.png',
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

  static List<SurveyModel> survey = [
    SurveyModel(
      text:
          'Да, оформил(а) и получил(а) свою первую пару зинз бесплатно в оптике',
    ),
    SurveyModel(
      text:
          'Да, но я не нашел(ла) времени активировать его и срок действия истёк ',
    ),
    SurveyModel(
      text: 'Да, но у меня возникли трудности с его активацией',
    ),
    SurveyModel(
      text: 'Я знаю про такую возможность,но не оформлял(а)',
    ),
  ];
}

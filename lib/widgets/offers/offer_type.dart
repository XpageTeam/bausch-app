/*
homeScreen - главный экран, (index) 1
notificationsScreen - Экран с уведомлениями (notifications) 1
offline - раздел Скидка 500 рублей в оптике ?
promoCodeImmediately - Предложения от партнеров (promo_code_immediately) 1
freeProduct - Бесплатная упаковка (free_product) ?
onlineShop - Скидка 500 рублей в интернет-магазине ?
promoCodeVideo - Записи вебинаров (promo_code_video) ?
onlineConsultation - Онлайн-консультация (online_consultation) 1
good - баннер у товара ?
*/

enum OfferType {
  homeScreen,
  notificationsScreen,
  offline,
  promoCodeImmediately,
  freeProduct,
  onlineShop,
  promoCodeVideo,
  onlineConsultation,
  good,
}

extension OfferTypeAsString on OfferType {
  String get asString {
    switch (this) {
      case OfferType.homeScreen:
        return 'index';
      case OfferType.notificationsScreen:
        return 'notifications';
      case OfferType.offline:
        return 'offline';
      case OfferType.promoCodeImmediately:
        return 'promo_code_immediately';
      case OfferType.freeProduct:
        return 'free_product';
      case OfferType.onlineShop:
        return 'onlineShop';
      case OfferType.promoCodeVideo:
        return 'promo_code_video';
      case OfferType.onlineConsultation:
        return 'online_consultation';
      case OfferType.good:
        return 'good';

      default:
        return 'index';
    }
  }
}

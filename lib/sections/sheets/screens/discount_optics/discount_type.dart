enum DiscountType {
  offline,
  onlineShop,
}

extension DiscountTypeAsString on DiscountType{
  String get asString => this == DiscountType.offline ? 'offline' : 'onlineShop';
}

enum DiscountTypeClass {
  offline,
  onlineShop,
}

extension DiscountTypeAsString on DiscountTypeClass{
  String get asString => this == DiscountTypeClass.offline ? 'offline' : 'onlineShop';
}

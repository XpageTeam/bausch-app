abstract class OrderData {
  final int orderID;

  final String? title;

  final String? subtitle;

  final String? promoCode;

  const OrderData({
    required this.orderID,
    this.title,
    this.subtitle,
    required this.promoCode,
  });
}
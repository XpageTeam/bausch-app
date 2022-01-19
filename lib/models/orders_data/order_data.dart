abstract class OrderData {
  final int orderID;

  final String? title;

  final String? subtitle;

  const OrderData({
    required this.orderID,
    this.title,
    this.subtitle,
  });
}
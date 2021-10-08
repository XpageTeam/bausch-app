/// Пока что используется просто как заглушка
class OrderItem {
  final String title;
  final String points;
  final String? imgLink;

  OrderItem({
    required this.title,
    this.points = '',
    this.imgLink,
  });

  /// Просто фабрика для создания тестового OrderItem
  factory OrderItem._test(int i) {
    return OrderItem(
      title: 'Раствор Biotrue универсальный ($i мл)',
      points: '13 000',
      // imgLink: 'wasd',
    );
  }

  /// Генератор List<OrderItem> размером [count]
  static List<OrderItem> generateList([int count = 3]) {
    return List<OrderItem>.generate(
      count,
      (i) => OrderItem._test(i),
    ).toList();
  }
}

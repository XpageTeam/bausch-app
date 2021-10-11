//* Заглушка
class ShopModel {
  final String title;
  final String address;
  final String phone;

  const ShopModel({
    required this.title,
    required this.address,
    required this.phone,
  });

  factory ShopModel.test() {
    return const ShopModel(
      title: 'ЛинзСервис',
      address: 'ул. Задарожная, д. 20, к. 2, ТЦ Океания',
      phone: '+7 920 325-62-26',
    );
  }

  static List<ShopModel> generate([int length = 3]) {
    return List<ShopModel>.generate(
      length,
      (i) => ShopModel.test(),
    );
  }
}

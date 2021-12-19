import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/mappable_object.dart';

class AddItemModel implements MappableInterface<AddItemModel> {
  final String title;
  final String subtitle;
  final String price;
  final String img;
  final String? type;

  final String htmlText;

  // TODO(Nikita): ??????
  String get priceString =>
      '+ ${HelpFunctions.partitionNumber(num.parse(price))}';

  AddItemModel({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.img,
    required this.htmlText,
    this.type = 'add',
  });

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

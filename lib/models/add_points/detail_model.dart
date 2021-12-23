import 'package:bausch/models/mappable_object.dart';

class DetailModel implements MappableInterface<DetailModel> {
  final String title;

  final String icon;

  final String? description;

  final String? btnName;

  final String? btnIcon;

  DetailModel({
    required this.title,
    required this.icon,
    this.description,
    this.btnName,
    this.btnIcon,
  });

  factory DetailModel.fromMap(Map<String, dynamic> map) {
    return DetailModel(
      title: (map['title'] ?? 'title') as String,
      icon: (map['icon'] ??
              'https://bausch.in-progress.ru/upload/uf/4fa/0ds4e7fo757lrxzlbxn5ji44co0vow8h.png')
          as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      btnName: map['btn_name'] != null ? map['btn_name'] as String : null,
      btnIcon: map['btn_icon'] != null ? map['btn_icon'] as String : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

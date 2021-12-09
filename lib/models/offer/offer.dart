import 'package:bausch/exceptions/response_parse_exception.dart';

class Offer {
  final int id;
  final String title;
  final String? description;
  final String? link;
  final bool isClosable;
  final String? html;
  // TODO(Nikolay): Возможно следует сделать отдельный класс Target, в котором будет описываться дальнейший переход.
  final String? target;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.isClosable,
    this.link,
    this.html,
    this.target,
  });

  factory Offer.fromJson(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException(
        'Не передан идентификатор специального предложения',
      );
    }

    return Offer(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      link: map['link'] as String?,
      isClosable: map['isClosable'] as bool,
      html: map['html'] as String?,
      target: map['target'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'link': link,
        'isClosable': isClosable,
        'html': html,
        'target': target,
      };
}

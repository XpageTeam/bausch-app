import 'package:bausch/exceptions/response_parse_exception.dart';

class SubscriptionModel {
  final String pointOfContact;
  final String? topic;
  final bool isSubscribed;

  SubscriptionModel({
    required this.pointOfContact,
    required this.isSubscribed,
    this.topic,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    try {
      return SubscriptionModel(
        pointOfContact: json['pointOfContact'] as String,
        topic: json['topic'] as String?,
        isSubscribed: json['isSubscribed'] as bool,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }

  Map toJson() => <String, dynamic>{
        'pointOfContact': pointOfContact,
        'topic': topic,
        'isSubscribed': isSubscribed,
      };
}

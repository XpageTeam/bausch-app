// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/user/user_model/balance.dart';
import 'package:bausch/models/user/user_model/user.dart';

class UserRepository {
  final Balance balance;
  final User user;

  String get userName => user.name ?? 'Новый друг';

  String get userScrore => HelpFunctions.partitionNumber(balance.total);

  int? get daysRemain => balance.nearestExpiration?.date
      ?.difference(
        DateTime.now(),
      )
      .inDays;

  String get lineLoadingText {
    final amount = balance.nearestExpiration?.amount ?? 0;
    if (canPrintLineLoadingText) {
      return '${HelpFunctions.partitionNumber(amount)} ${HelpFunctions.wordByCount(
        amount.toInt(),
        [
          'баллов сгорят',
          'балл сгорит',
          'балла сгорят',
        ],
      )} через $daysRemain ${HelpFunctions.wordByCount(
        daysRemain!,
        [
          'дней',
          'день',
          'дня',
        ],
      )}';
    } else {
      return '';
    }
  }

  bool get canPrintLineLoadingText {
    final amount = balance.nearestExpiration?.amount;
    if (daysRemain != null && daysRemain! > 0 && amount != null) {
      return true;
    } else {
      return false;
    }
  }

  const UserRepository({
    required this.balance,
    required this.user,
  });

  factory UserRepository.fromJson(Map<String, dynamic> json) {
		try {
			return UserRepository(
				balance: Balance.fromJson(json['balance'] as Map<String, dynamic>),
				user: User.fromJson(json['user'] as Map<String, dynamic>),
			);
		} on ResponseParseException{
			rethrow;
		} catch (e){
			throw ResponseParseException(e.toString());
		}
  }

  @override
  String toString() => 'UserModel(balance: $balance, user: $user)';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'balance': balance.toJson(),
        'user': user.toJson(),
      };

  UserRepository copyWith({
    Balance? balance,
    User? user,
  }) {
    return UserRepository(
      balance: balance ?? this.balance,
      user: user ?? this.user,
    );
  }
}

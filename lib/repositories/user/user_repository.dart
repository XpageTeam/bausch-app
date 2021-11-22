import 'package:bausch/models/user/user_model/balance.dart';
import 'package:bausch/models/user/user_model/user.dart';

class UserRepository {
  final Balance balance;
  final User user;

  String get userName => user.name ?? 'Новый друг';

  num get userScrore => balance.total;

  const UserRepository({
    required this.balance,
    required this.user,
  });

  factory UserRepository.fromJson(Map<String, dynamic> json) => UserRepository(
        balance: Balance.fromJson(json['balance'] as Map<String, dynamic>),
        user: User.fromJson(json['user'] as Map<String, dynamic>),
      );

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

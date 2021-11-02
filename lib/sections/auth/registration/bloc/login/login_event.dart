part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  final String phone;

  const LoginEvent({required this.phone});
}

class LoginSetPhone extends LoginEvent {
  final bool isPhoneValid;
  const LoginSetPhone({
    required String phone,
    required this.isPhoneValid,
  }) : super(
          phone: phone,
        );
}

class LoginSendPhone extends LoginEvent {
  const LoginSendPhone({
    required String phone,
  }) : super(
          phone: phone,
        );
}

part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  final String phone;

  const LoginState({required this.phone});
}

class LoginInitial extends LoginState {
  const LoginInitial() : super(phone: '');
}

class LoginFailed extends LoginState {
  final String title;
  final String? subtitle;

  const LoginFailed({required this.title, required String phone, this.subtitle})
      : super(phone: phone);
}

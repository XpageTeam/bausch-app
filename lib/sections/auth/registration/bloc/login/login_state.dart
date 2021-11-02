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

class LoginPhoneSetted extends LoginState {
  final bool isPhoneValid;
  const LoginPhoneSetted({
    required String phone,
    required this.isPhoneValid,
  }) : super(
          phone: phone,
        );
}

class LoginPhoneSending extends LoginState {
  const LoginPhoneSending({
    required String phone,
  }) : super(
          phone: phone,
        );
}

class LoginPhoneSended extends LoginState {
  const LoginPhoneSended({
    required String phone,
  }) : super(
          phone: phone,
        );
}

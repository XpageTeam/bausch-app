import 'package:bausch/sections/home/home_screen.dart';

/// Класс, который хранит в себе начальный Link из пуша, по которому прошло нажатие и из-за которого произошло открытие приложения
/// В классе _HomeScreenState (State of HomeScreen) в методе initState подробнее описано про логику
class InitialPushIntentKeeper {
  static final InitialPushIntentKeeper _singleton =
      InitialPushIntentKeeper._internal();
  static String? link;

  factory InitialPushIntentKeeper() {
    return _singleton;
  }

  InitialPushIntentKeeper._internal();
}

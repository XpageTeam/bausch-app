import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/user/user_model/user.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class UserWM extends WidgetModel {
  final userData = EntityStreamedState<UserRepository>();

  UserWM() : super(const WidgetModelDependencies());

  /// Метод изменения данных пользователя
  /// обработка и отображение ошибок уже содержатся в нём
  Future<bool> updateUserData(User userData) async {
    late CustomException ex;

    try {
      await this.userData.content(await UserWriter.updateUserData(userData));

      showDefaultNotification(title: 'Данные успешно обновлены!');

      return true;
    } on DioError catch (e) {
      ex = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }

    _showTopError(ex);

    return false;
  }

  void _showTopError(CustomException ex) {
    showDefaultNotification(
      title: ex.title,
      subtitle: ex.subtitle,
    );
  }
}

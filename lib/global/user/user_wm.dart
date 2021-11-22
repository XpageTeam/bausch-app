import 'package:bausch/repositories/user/user_repository.dart';
import 'package:surf_mwwm/surf_mwwm.dart';


// TODO: выход необходимо реализовывать тут
class UserWM extends WidgetModel {

  final userData = EntityStreamedState<UserRepository>();

  UserWM(WidgetModelDependencies baseDependencies) : super(baseDependencies);


}
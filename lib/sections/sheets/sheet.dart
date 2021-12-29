import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Виждет-контейнер для страниц, которые открываются в bottomSheet
class SheetWidget extends StatelessWidget {
  final Widget child;

  const SheetWidget({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userWm = Provider.of<UserWM>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          //* Виджет с количеством баллов
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: EntityStateBuilder<UserRepository>(
                  streamedState: userWm.userData,
                  builder: (_, userData) {
                    return PointsInfo(
                      text: HelpFunctions.partitionNumber(
                        userData.balance.available,
                      ),
                      backgoundColor: AppTheme.mystic,
                    );
                  },
                ),
              ),
            ],
          ),

          Flexible(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                //* Сама страница
                child,

                //* Штука, за которую можно тянуть
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    height: 4,
                    width: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.mineShaft,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

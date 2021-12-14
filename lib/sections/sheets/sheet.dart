import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Виждет-контейнер для страниц, которые открываются в bottomSheet
class SheetWidget extends StatelessWidget {
  final Widget child;

  const SheetWidget({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final points =
        Provider.of<UserWM>(context).userData.value.data?.balance.available ??
            0;

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
                child: PointsInfo(
                  text: points.toString(),
                  backgoundColor: AppTheme.mystic,
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

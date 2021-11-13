import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';

//* Виждет-контейнер для страниц, которые открываются в bottomSheet
class SheetWidget extends StatelessWidget {
  final Widget child;

  const SheetWidget({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          //* Виджет с количеством баллов
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: PointsInfo(
                  text: '500',
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

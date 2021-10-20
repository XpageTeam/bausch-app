import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetContent extends StatelessWidget {
  final String title;
  final String btnText;
  final String? subtitle;
  final String? phone;
  final String? site;
  final String? additionalInfo;
  final VoidCallback? onPressed;
  const BottomSheetContent({
    required this.title,
    required this.btnText,
    this.subtitle,
    this.phone,
    this.onPressed,
    this.site,
    this.additionalInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        4,
        StaticData.sidePadding,
        24,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Чёрная пимпочка
          Center(
            child: Container(
              height: 4,
              margin: const EdgeInsets.only(
                bottom: 2,
              ),
              width: MediaQuery.of(context).size.width / 9.87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.mineShaft,
              ),
            ),
          ),

          // Кнопка закрыть
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: NormalIconButton(
              backgroundColor: AppTheme.mystic,
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.close,
                color: AppTheme.mineShaft,
              ),
            ),
          ),

          // Название
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: AppStyles.h2Bold,
              ),
            ),
          ),

          // Адрес
          if (subtitle != null)
            Flexible(
              child: Text(
                subtitle!,
                style: AppStyles.p1,
              ),
            ),

          // Телефон
          if (phone != null)
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  final url = 'tel:$phone';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    await Future<dynamic>.error('Could not launch $url');
                  }
                },
                child: Text(
                  phone!,
                  style: AppStyles.p1.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.turquoiseBlue,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ),

          // Сайт
          if (site != null)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    // TODO(Nikolay): Реализовать переход на сайт.
                    // final url = 'tel:$site';
                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   await Future<dynamic>.error('Could not launch $url');
                    // }
                  },
                  child: Text(
                    site!,
                    style: AppStyles.p1.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.turquoiseBlue,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
            ),

          // Доп. информация о скидке
          if (additionalInfo != null)
            Flexible(
              child: Text(
                additionalInfo!,
                style: AppStyles.p1.copyWith(
                  color: Colors.black,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: BlueButton(
              onPressed: onPressed,
              children: [
                Text(
                  btnText,
                  //'Хорошо',
                  style: AppStyles.h2Bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

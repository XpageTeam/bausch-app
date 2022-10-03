import 'package:bausch/help/utils.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BottomSheetContent extends StatelessWidget {
  final String title;
  final String btnText;
  final String? subtitle;
  final List<String>? phones;
  final String? site;
  final String? additionalInfo;
  final VoidCallback? onPressed;
  const BottomSheetContent({
    required this.title,
    required this.btnText,
    this.subtitle,
    this.phones,
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

          // Номера
          if (phones != null)
            ...phones!
                .map(
                  (phone) => Flexible(
                    child: GestureDetector(
                      onTap: () => Utils.tryLaunchUrl(
                        rawUrl: phone,
                        isPhone: true,
                      ),
                      child: Text(
                        phone,
                        style: AppStyles.p1.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.turquoiseBlue,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),

          // if (phone.is != null)
          //   Flexible(
          //     child: GestureDetector(
          //       onTap: () => Utils.tryLaunchUrl(rawUrl: phone!, isPhone: true),
          //       child: Text(
          //         phone!,
          //         style: AppStyles.p1.copyWith(
          //           decoration: TextDecoration.underline,
          //           decorationColor: AppTheme.turquoiseBlue,
          //           decorationThickness: 2,
          //         ),
          //       ),
          //     ),
          //   ),

          // Сайт
          if (site != null)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () => Utils.tryLaunchUrl(
                    rawUrl: site!,
                    onError: (ex) {
                      showDefaultNotification(
                        title: ex.title,
                        subtitle: ex.subtitle,
                      );
                    },
                  ),
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

class BottomSheetContentOther extends StatelessWidget {
  final String title;
  final String btnText;
  final String? subtitle;
  final List<String>? phones;
  final String? site;
  final String? additionalInfo;
  final ScrollController controller;
  final VoidCallback? onPressed;
  const BottomSheetContentOther({
    required this.title,
    required this.btnText,
    required this.controller,
    required this.onPressed,
    this.subtitle,
    this.phones,
    this.site,
    this.additionalInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 14 + 44 + 20,
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

                  // Номера
                  if (phones != null)
                    ...phones!
                        .map(
                          (phone) => Flexible(
                            child: GestureDetector(
                              onTap: () => Utils.tryLaunchUrl(
                                rawUrl: phone,
                                isPhone: true,
                              ),
                              child: Text(
                                phone,
                                style: AppStyles.p1.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppTheme.turquoiseBlue,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),

                  // if (phone.is != null)
                  //   Flexible(
                  //     child: GestureDetector(
                  //       onTap: () => Utils.tryLaunchUrl(rawUrl: phone!, isPhone: true),
                  //       child: Text(
                  //         phone!,
                  //         style: AppStyles.p1.copyWith(
                  //           decoration: TextDecoration.underline,
                  //           decorationColor: AppTheme.turquoiseBlue,
                  //           decorationThickness: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ),

                  // Сайт
                  if (site != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: GestureDetector(
                          onTap: () => Utils.tryLaunchUrl(
                            rawUrl: site!,
                            onError: (ex) {
                              showDefaultNotification(
                                title: ex.title,
                                subtitle: ex.subtitle,
                              );
                            },
                          ),
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

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 30.0),
                  //   child: BlueButton(
                  //     onPressed: onPressed,
                  //     children: [
                  //       Text(
                  //         btnText,
                  //         //'Хорошо',
                  //         style: AppStyles.h2Bold,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                0,
                StaticData.sidePadding,
                20,
              ),
              child: BlueButton(
                onPressed: onPressed,
                children: const [
                  Text(
                    'Выбрать эту сеть оптик',
                    style: AppStyles.h2Bold,
                  ),
                ],
              ),
            ),
          ),
          // Чёрная пимпочка
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  height: 4,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppTheme.mineShaft,
                  ),
                ),
              ),
            ),
          ),

          // Кнопка закрыть
          Positioned(
            top: 14,
            right: 12,
            child: Container(
              alignment: Alignment.centerRight,
              child: NormalIconButton(
                backgroundColor: AppTheme.mystic,
                onPressed: Navigator.of(context).pop,
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.mineShaft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

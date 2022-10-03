import 'package:bausch/help/utils.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';

class ShopContainer extends StatelessWidget {
  final OpticShop shop;
  const ShopContainer({
    required this.shop,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(StaticData.sidePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shop.title,
            style: AppStyles.h2Bold,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            shop.address,
            style: AppStyles.p1,
          ),
          const SizedBox(
            height: 4,
          ),
          ...shop.phones
              .map(
                (phone) => GestureDetector(
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
              )
              .toList(),
          // GestureDetector(
          //   onTap: () => Utils.tryLaunchUrl(
          //     rawUrl:
          //         shop.phone[0],
          //     isPhone: true,
          //   ),
          //   child: Text(
          //     shop.phone[0],
          //     style: AppStyles.p1.copyWith(
          //       decoration: TextDecoration.underline,
          //       decorationColor: AppTheme.turquoiseBlue,
          //       decorationThickness: 2,
          //     ),
          //   ),
          // ),
          if (shop.site != null) ...[
            const SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () => Utils.tryLaunchUrl(
                rawUrl: shop.site!,
                onError: (ex) {
                  showDefaultNotification(
                    title: ex.title,
                    // subtitle: ex.subtitle,
                  );
                },
              ),
              child: Text(
                shop.site!,
                style: AppStyles.p1.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.turquoiseBlue,
                  decorationThickness: 2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

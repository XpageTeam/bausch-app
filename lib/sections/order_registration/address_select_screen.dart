import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class AddressSelectScreen extends StatelessWidget {
  const AddressSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Адрес доставки',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: FocusButton(
                labelText: 'Город',
                selectedText: 'Москва',
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return CityScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            FocusButton(
              labelText: 'Адрес',
              selectedText: 'Александра Чавчавадзе, 9',
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return AddDetailsScreen(
                        adress: AdressModel(
                          street: 'Александра Чавчавадзе',
                          house: '9',
                        ),
                        isFirstLaunch: true,
                        btnText: 'Перейти к заказу',
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: BlueButtonWithText(
          text: 'Перейти к заказу',
          onPressed: () {
            showFlexibleBottomSheet<void>(
              context: Keys.mainNav.currentContext!,
              minHeight: 0,
              initHeight: 0.9,
              maxHeight: 0.95,
              anchors: [0, 0.6, 0.95],
              builder: (context, controller, d) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    FinalFreePackaging(
                      controller: ScrollController(),
                      model: Models.discountOptics[0],
                    ),
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
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

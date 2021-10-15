// ignore_for_file: unused_import

import 'package:bausch/models/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/add_adress_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class MyAdressesScreen extends StatefulWidget {
  MyAdressesScreen({Key? key}) : super(key: key);

  @override
  _MyAdressesScreenState createState() => _MyAdressesScreenState();
}

class _MyAdressesScreenState extends State<MyAdressesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Мои адреса',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
          top: 30,
        ),
        child: Adresses.adresses.isEmpty
            ? const Text(
                'Пока нет ни одного адреса для доставки ',
                style: AppStyles.h1,
              )
            : ListView.builder(
                itemCount: Adresses.adresses.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: Adresses.adresses[i].street,
                      selectedText:
                          'Кв.${Adresses.adresses[i].office},подъезд ${Adresses.adresses[i].lobby},этаж ${Adresses.adresses[i].floor}',
                      onPressed: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddDetailsScreen(
                                adress: Adresses.adresses[i],
                                isFirstLaunch: false,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: BlueButtonWithText(
          text: 'Добавить адрес',
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) {
                  return AddAdressScreen();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

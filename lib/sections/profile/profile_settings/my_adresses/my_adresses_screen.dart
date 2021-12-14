// ignore_for_file: unused_import

import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/bloc/addresses_bloc.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/address_button.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/info_widget.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/pages/error_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAdressesScreen extends StatefulWidget {
  const MyAdressesScreen({Key? key}) : super(key: key);

  @override
  _MyAdressesScreenState createState() => _MyAdressesScreenState();
}

class _MyAdressesScreenState extends State<MyAdressesScreen> {
  final adressesCubit = AdressesCubit();

  @override
  void dispose() {
    super.dispose();
    adressesCubit.close();
  }

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
        child: ListView.builder(
          itemCount: Adresses.adresses.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: AddressButton(
                labelText:
                    '${Adresses.adresses[i].street}, ${Adresses.adresses[i].house}',
                selectedText:
                    'Кв.${Adresses.adresses[i].flat},подъезд ${Adresses.adresses[i].entry},этаж ${Adresses.adresses[i].floor}',
                onPressed: () {
                  Keys.mainContentNav.currentState!
                      .pushNamed(
                    '/add_details',
                    arguments: AddDetailsArguments(
                      adress: Adresses.adresses[i],
                      isFirstLaunch: false,
                    ),
                  )
                      .then((v) {
                    //adressesCubit.getAdresses();
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: BlueButtonWithText(
          text: 'Добавить адрес',
          onPressed: () {
            Keys.mainContentNav.currentState!
                .pushNamed('/add_adress')
                .then((v) {
              //adressesCubit.getAdresses();
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

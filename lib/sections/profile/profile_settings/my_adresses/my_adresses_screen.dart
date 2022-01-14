// ignore_for_file: unused_import

import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/bloc/addresses_bloc.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/address_button.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/pages/error_page.dart';
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(
          StaticData.sidePadding,
          0,
          StaticData.sidePadding,
          StaticData.sidePadding,
        ),
        child: BlueButtonWithText(
          text: 'Добавить адрес',
          onPressed: () {
            Keys.mainContentNav.currentState!
                .pushNamed('/add_adress')
                .then((v) {
              adressesCubit.getAdresses();
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.only(
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
          top: 30,
        ),
        child: BlocBuilder<AdressesCubit, AdressesState>(
          bloc: adressesCubit,
          builder: (context, state) {
            if (state is GetAdressesSuccess) {
              if (state.adresses.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.adresses.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: AddressButton(
                        labelText:
                            '${state.adresses[i].street}, ${state.adresses[i].house}',
                        selectedText: (state.adresses[i].flat != null &&
                                state.adresses[i].entry != null &&
                                state.adresses[i].floor != null)
                            ? 'Кв.${state.adresses[i].flat},подъезд ${state.adresses[i].entry},этаж ${state.adresses[i].floor}'
                            : null,
                        onPressed: () {
                          Keys.mainContentNav.currentState!
                              .pushNamed(
                            '/add_details',
                            arguments: AddDetailsArguments(
                              adress: state.adresses[i],
                              isFirstLaunch: false,
                            ),
                          )
                              .then((v) {
                            adressesCubit.getAdresses();
                          });
                        },
                      ),
                    );
                  },
                );
              } else {
                return Text(
                  'Пока нет ни одного адреса для доставки ',
                  style: AppStyles.h1,
                );
              }
            }

            if (state is AdressesFailed) {
              return ErrorPage(
                title: state.title,
                subtitle: state.subtitle,
                buttonCallback: adressesCubit.getAdresses,
                buttonText: 'Обновить',
              );
            }

            return const Center(child: AnimatedLoader());
          },
        ),
      ),
    );
  }
}

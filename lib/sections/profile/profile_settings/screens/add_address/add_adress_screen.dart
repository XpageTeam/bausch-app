// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/AddressEditForm/bloc/Dadata/dadata_bloc.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AddAdressScreen extends StatefulWidget {
  const AddAdressScreen({Key? key}) : super(key: key);

  @override
  _AddAdressScreenState createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  // late final UserWM userWM;

  late final DadataBloc dadataBloc;

  TextEditingController controller = TextEditingController();

  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    dadataBloc.close();
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    // userWM = Provider.of<UserWM>(context, listen: false);
    dadataBloc = DadataBloc(/*city: userWM.userData.value.data!.user.city!*/);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Добавить адрес',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
          top: 30,
        ),
        child: Column(
          children: [
            NativeTextInput(
              labelText: 'Поиск адреса',
              controller: controller,
              onChanged: delayedSearch,
            ),
            BlocBuilder<DadataBloc, DadataState>(
              bloc: dadataBloc,
              builder: (context, state) {
                debugPrint(state.toString());
                if (state is DadataSuccess) {
                  //debugPrint(state.models[0].data.street);
                  if (state.models.isNotEmpty) {
                    return Flexible(
                      child: ListView.separated(
                        itemBuilder: (context, i) {
                          if (state.models[i].data.street.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: i == 0 ? 30 : 0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  //* Если выбрал улицу без номера дома
                                  if (state.models[i].data.house.isNotEmpty) {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          text: state.models[i].data.block ==
                                                  null
                                              ? 'Добавить ${state.models[i].data.street}, ${state.models[i].data.house}?'
                                              : 'Добавить ${state.models[i].data.street}, ${state.models[i].data.house}/${state.models[i].data.block}?',
                                          yesCallback: () {
                                            Navigator.of(context).pop();

                                            final currentFocus =
                                                FocusScope.of(context);

                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }

                                            Navigator.of(context).pushNamed(
                                              '/add_details',
                                              arguments: AddDetailsArguments(
                                                adress: AdressModel(
                                                  street: state
                                                      .models[i].data.street,
                                                  house: state.models[i].data
                                                              .block ==
                                                          null
                                                      ? state
                                                          .models[i].data.house
                                                      : '${state.models[i].data.house}/${state.models[i].data.block}',
                                                  zipCode: state.models[i].data
                                                      .postalCode,
                                                ),
                                                isFirstLaunch: true,
                                              ),
                                            );
                                          },
                                          noCallback: Navigator.of(context).pop,
                                        );
                                      },
                                    );
                                  } else {
                                    //* Если выбрал и улицу, и дом
                                    controller
                                      ..text = '${state.models[i].value} '
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                          offset: controller.text.length,
                                        ),
                                      );
                                    delayedSearch(
                                      '${state.models[i].value} ',
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // state.models[i].data.house.isNotEmpty
                                      //     ? state.models[i].data.block == null
                                      //         ? '${state.models[i].data.street}, ${state.models[i].data.house}'
                                      //         : '${state.models[i].data.street}, ${state.models[i].data.house}/${state.models[i].data.block}'
                                      //     : state.models[i].data.street,
                                      state.models[i].value,
                                      style: AppStyles.h2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                        separatorBuilder: (context, i) {
                          if (state.models[i].data.street.isNotEmpty) {
                            return const SizedBox(
                              height: 30,
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                        itemCount: state.models.length,
                        physics: const BouncingScrollPhysics(),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        'По вашему запросу ничего не найдено',
                        style: AppStyles.h2,
                      ),
                    );
                  }
                }
                if (state is DadataInitial) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Начните вводить адрес',
                      style: AppStyles.h2,
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: AnimatedLoader(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //* Поиск с задержкой 1 сек
  void delayedSearch(String str) {
    if (str.isNotEmpty) {
      if (mounted) {
        if (timer?.isActive ?? false) {
          timer?.cancel();
        }
        timer = Timer(const Duration(milliseconds: 300), () {
          debugPrint(str);
          dadataBloc.add(DadataChangeText(text: str));
        });
      }
    } else {
      if (mounted) {
        timer?.cancel();
        dadataBloc.add(DadataSetEmptyField());
      }
    }
  }
}

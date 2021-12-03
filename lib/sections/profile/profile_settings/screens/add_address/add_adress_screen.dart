import 'dart:async';

import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/adress_model.dart';
import 'package:bausch/packages/alphabet_scroll_view/lib/alphabet_scroll_view.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/bloc/addresses_bloc.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/AddressEditForm/bloc/Dadata/dadata_bloc.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
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
  late final UserWM userWM;

  late final DadataBloc dadataBloc;

  TextEditingController controller = TextEditingController();

  Timer? timer;

  List<AdressModel> filteredList = [];

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
    userWM = Provider.of<UserWM>(context, listen: false);
    dadataBloc = DadataBloc(city: userWM.userData.value.data!.user.city!);
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
            DefaultTextInput(
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
                  return Flexible(
                    child: ListView.separated(
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.only(top: i == 0 ? 30 : 0),
                          child: SizedBox(
                            height: 30,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                if (state.models[i].data.house.isNotEmpty) {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        text: 'Добавить выбранный адрес?',
                                        yesCallback: () {
                                          Navigator.of(context).pop();

                                          Keys.mainContentNav.currentState!
                                              .pushNamed(
                                            '/add_details',
                                            arguments: AddDetailsArguments(
                                              adress: AdressModel(
                                                street:
                                                    state.models[i].data.street,
                                                house:
                                                    state.models[i].data.house,
                                              ),
                                              isFirstLaunch: true,
                                            ),
                                          );
                                        },
                                        noCallback: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  controller.text = state.models[i].data.street;
                                  delayedSearch(
                                    '${state.models[i].data.street}, ',
                                  );
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.models[i].data.house.isNotEmpty
                                        ? '${state.models[i].data.street}, ${state.models[i].data.house}'
                                        : state.models[i].data.street,
                                    style: AppStyles.h2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return const SizedBox(
                          height: 30,
                        );
                      },
                      itemCount: state.models.length,
                      physics: const BouncingScrollPhysics(),
                    ),
                  );
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

  void delayedSearch(String str) {
    if (str.isNotEmpty) {
      if (mounted) {
        if (timer?.isActive ?? false) {
          timer?.cancel();
        }
        timer = Timer(const Duration(seconds: 1), () {
          debugPrint(str);
          dadataBloc.add(DadataChangeText(text: str));
        });
      }
    } else {
      dadataBloc.add(DadataSetEmptyField());
    }
  }
}

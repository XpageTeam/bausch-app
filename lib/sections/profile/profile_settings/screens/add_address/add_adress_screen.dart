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
              // onChanged: (s) {
              //   setState(
              //     () {
              //       filteredList.clear();
              //       for (var i = 0; i < Adresses.streets.length; i++) {
              //         final str = Adresses.adresses[i].street.toLowerCase();
              //         if (str.contains(s.toLowerCase())) {
              //           filteredList.add(Adresses.adresses[i]);
              //         }
              //       }
              //     },
              //   );
              // },
              onChanged: (str) {
                if (mounted && str.isNotEmpty) {
                  if (timer?.isActive ?? false) {
                    timer?.cancel();
                  }
                  timer = Timer(const Duration(seconds: 1), () {
                    debugPrint(str);
                    dadataBloc.add(DadataChangeText(text: str));
                  });
                }
              },
            ),
            BlocBuilder<DadataBloc, DadataState>(
              bloc: dadataBloc,
              builder: (context, state) {
                debugPrint(state.toString());
                if (state is DadataSuccess) {
                  //debugPrint(state.models[0].data.street);
                  return Flexible(
                    child: AlphabetScrollView(
                      list: state.models
                          .map((e) => AlphaModel(
                                '${e.data.street}, ${e.data.house}',
                              ))
                          .toList(),
                      selectedTextStyle: AppStyles.h1,
                      unselectedTextStyle: AppStyles.h2,
                      itemExtent: 60,
                      itemBuilder: (context, i, str) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Keys.mainContentNav.currentState!.pushNamed(
                                  '/add_details',
                                  arguments: AddDetailsArguments(
                                    adress: AdressModel(
                                      street: state.models[i].data.street,
                                      house: state.models[i].data.house,
                                    ),
                                    isFirstLaunch: true,
                                  ),
                                );
                              },
                              child: Text(
                                str,
                                style: AppStyles.h2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
                return const AnimatedLoader();
              },
            ),
          ],
        ),
      ),
    );
  }
}

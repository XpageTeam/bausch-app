import 'package:bausch/models/adress_model.dart';
import 'package:bausch/packages/alphabet_scroll_view/lib/alphabet_scroll_view.dart';
import 'package:bausch/sections/profile/profile_settings/add_adress_details_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';

class AddAdressScreen extends StatefulWidget {
  const AddAdressScreen({Key? key}) : super(key: key);

  @override
  _AddAdressScreenState createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  TextEditingController controller = TextEditingController();

  List<String> filteredList = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
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
              onChanged: (s) {
                setState(
                  () {
                    filteredList.clear();
                    for (var i = 0; i < Adresses.streets.length; i++) {
                      final str = Adresses.streets[i].toLowerCase();
                      if (str.contains(s.toLowerCase())) {
                        filteredList.add(Adresses.streets[i]);
                      }
                    }
                  },
                );
              },
            ),
            Flexible(
              child: AlphabetScrollView(
                list: controller.value.text.isEmpty
                    ? Adresses.streets.map((e) => AlphaModel(e)).toList()
                    : filteredList.map((e) => AlphaModel(e)).toList(),
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
                              adress: AdressModel(street: str),
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
            ),
          ],
        ),
      ),
    );
  }
}

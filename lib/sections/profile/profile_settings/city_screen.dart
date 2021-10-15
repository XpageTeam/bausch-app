import 'package:bausch/packages/alphabet_scroll_view/lib/alphabet_scroll_view.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({Key? key}) : super(key: key);

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  TextEditingController controller = TextEditingController();

  List<String> filteredList = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Город',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
        ),
        child: Column(
          children: [
            DefaultTextInput(
              labelText: 'Найти город',
              controller: controller,
              onChanged: (s) {
                setState(
                  () {
                    filteredList.clear();

                    //* Фильтрация по поисковому запросу
                    for (var i = 0; i < Adresses.cities.length; i++) {
                      final str = Adresses.cities[i].toLowerCase();
                      if (str.contains(s.toLowerCase())) {
                        filteredList.add(Adresses.cities[i]);
                      }
                    }
                  },
                );
              },
            ),

            //TODO(Nikita): Добавить сверху избранные города и выбранный
            Flexible(
              child: AlphabetScrollView(
                itemExtent: 60,
                list: controller.value.text.isEmpty
                    ? Adresses.cities.map((e) => AlphaModel(e)).toList()
                    : filteredList.map((e) => AlphaModel(e)).toList(),
                selectedTextStyle: AppStyles.h1,
                unselectedTextStyle: AppStyles.h2,
                itemBuilder: (context, i, cityName) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityName,
                        style: AppStyles.h2,
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

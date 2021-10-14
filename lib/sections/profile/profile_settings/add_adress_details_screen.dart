import 'package:bausch/models/adress_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';

class AddDetailsScreen extends StatefulWidget {
  final String adress;
  const AddDetailsScreen({
    required this.adress,
    Key? key,
  }) : super(key: key);

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  TextEditingController officeController = TextEditingController();
  TextEditingController lobbyController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    officeController.dispose();
    lobbyController.dispose();
    floorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Адрес доставки',
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
            Text(widget.adress, style: AppStyles.h1),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: DefaultTextInput(
                    labelText: 'Кв/офис',
                    controller: officeController,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: DefaultTextInput(
                    labelText: 'Подъезд',
                    controller: lobbyController,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: DefaultTextInput(
                    labelText: 'Этаж',
                    controller: floorController,
                    inputType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: BlueButtonWithText(
          text: 'Сохранить',
          onPressed: () {
            Adresses.adresses.add(
              AdressModel(
                street: widget.adress,
                office: int.parse(officeController.value.text),
                floor: int.parse(floorController.value.text),
                lobby: int.parse(lobbyController.value.text),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

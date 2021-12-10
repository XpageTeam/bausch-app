// ignore_for_file: unused_import

import 'package:bausch/models/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/add_adress_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:bausch/widgets/buttons/text_button_icon.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDetailsArguments {
  final AdressModel adress;
  final bool isFirstLaunch;

  AddDetailsArguments({required this.adress, required this.isFirstLaunch});
}

class AddDetailsScreen extends StatefulWidget implements AddDetailsArguments {
  @override
  final bool isFirstLaunch;
  @override
  final AdressModel adress;
  const AddDetailsScreen({
    required this.adress,
    required this.isFirstLaunch,
    Key? key,
  }) : super(key: key);

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  late TextEditingController officeController;
  late TextEditingController lobbyController;
  late TextEditingController floorController;

  @override
  void dispose() {
    super.dispose();

    officeController.dispose();
    lobbyController.dispose();
    floorController.dispose();
  }

  @override
  void initState() {
    super.initState();

    officeController = TextEditingController(
      text: widget.adress.office == null ? '' : widget.adress.office.toString(),
    );

    lobbyController = TextEditingController(
      text: widget.adress.lobby == null ? '' : widget.adress.lobby.toString(),
    );

    floorController = TextEditingController(
      text: widget.adress.floor == null ? '' : widget.adress.floor.toString(),
    );
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
            Text(widget.adress.street, style: AppStyles.h1),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: NativeTextInput(
                    labelText: 'Кв/офис',
                    controller: officeController,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: NativeTextInput(
                    labelText: 'Подъезд',
                    controller: lobbyController,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: NativeTextInput(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlueButtonWithText(
              text: 'Сохранить',
              onPressed: () {
                _addAdress();
                _navigateBack();
              },
            ),
            if (!widget.isFirstLaunch)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CustomTextButtonIcon(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      builder: (context) {
                        return CustomAlertDialog(
                          yesCallback: () {
                            final index =
                                Adresses.adresses.indexOf(widget.adress);
                            Adresses.adresses.removeAt(index);
                            _navigateBack();
                            Navigator.of(context).pop();
                          },
                          noCallback: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //TODO(Nikita): Заменить на popUntil.withName
  void _navigateBack() {
    if (widget.isFirstLaunch) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      //* popUntil не работает
      // Navigator.of(context)
      //     .popUntil((route) => route.settings.name == '/my_adresses');
    } else {
      Navigator.of(context).pop();
    }
  }

  void _addAdress() {
    if (!Adresses.adresses.contains(widget.adress)) {
      Adresses.adresses.add(
        AdressModel(
          street: widget.adress.street,
          office: int.parse(officeController.value.text),
          floor: int.parse(floorController.value.text),
          lobby: int.parse(lobbyController.value.text),
        ),
      );
    } else {
      final index = Adresses.adresses.indexOf(widget.adress);
      Adresses.adresses[index] = AdressModel(
        street: widget.adress.street,
        office: int.parse(officeController.value.text),
        floor: int.parse(floorController.value.text),
        lobby: int.parse(lobbyController.value.text),
      );
    }
  }
}

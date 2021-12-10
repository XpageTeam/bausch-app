// ignore_for_file: unused_import

import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/bloc/addresses_bloc.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDetailsArguments {
  final AdressModel adress;
  final bool isFirstLaunch;

  AddDetailsArguments({
    required this.adress,
    required this.isFirstLaunch,
  });
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
  final AddressesBloc addressesBloc = AddressesBloc();

  late TextEditingController flatController;
  late TextEditingController entryController;
  late TextEditingController floorController;

  @override
  void dispose() {
    super.dispose();

    addressesBloc.close();

    flatController.dispose();
    entryController.dispose();
    floorController.dispose();
  }

  @override
  void initState() {
    super.initState();

    //addressesBloc = BlocProvider.of<AddressesBloc>(context);

    flatController = TextEditingController(
      text: widget.adress.flat == null ? '' : widget.adress.flat.toString(),
    );

    entryController = TextEditingController(
      text: widget.adress.entry == null ? '' : widget.adress.entry.toString(),
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
            Text(
              '${widget.adress.street}, ${widget.adress.house}',
              style: AppStyles.h1,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: NativeTextInput(
                    labelText: 'Кв/офис',
                    controller: flatController,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: NativeTextInput(
                    labelText: 'Подъезд',
                    controller: entryController,
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
                final model = AdressModel(
                  street: widget.adress.street,
                  house: widget.adress.house,
                  flat: int.parse(flatController.text),
                  entry: int.parse(entryController.text),
                  floor: int.parse(floorController.text),
                );

                addressesBloc.add(AddressesSend(address: model));
                //widget.adressesCubit?.getAdresses();

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
                            addressesBloc
                                .add(AddressesDelete(id: widget.adress.id!));

                            //widget.adressesCubit?.getAdresses();

                            debugPrint('delete');
                            debugPrint(addressesBloc.state.toString());

                            _navigateBack();
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
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

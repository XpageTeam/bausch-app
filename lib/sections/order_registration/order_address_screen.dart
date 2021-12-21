// ignore_for_file: unused_import

import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/order_registration/widget_models/order_address_screen_wm.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/bloc/addresses_bloc.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/adresses.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:bausch/widgets/buttons/text_button_icon.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OrderAddressScreenArguments {
  final AdressModel adress;

  OrderAddressScreenArguments({
    required this.adress,
  });
}

class OrderAddressScreen extends CoreMwwmWidget<OrderAddressScreenWM>
    implements OrderAddressScreenArguments {
  @override
  final AdressModel adress;

  final String? btnText;
  OrderAddressScreen({
    required this.adress,
    this.btnText,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => OrderAddressScreenWM(
            context: context,
            adress: adress,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<OrderAddressScreenWM>, OrderAddressScreenWM>
      createWidgetState() => _OrderAddressScreenState();
}

class _OrderAddressScreenState
    extends WidgetState<OrderAddressScreen, OrderAddressScreenWM> {
  late TextEditingController flatController;
  late TextEditingController entryController;
  late TextEditingController floorController;

  @override
  void dispose() {
    super.dispose();

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 60,
          ),
          child: BlueButtonWithText(
            text: 'Перейти к заказу',
            onPressed: () {},
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

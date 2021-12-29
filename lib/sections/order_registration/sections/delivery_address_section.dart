import 'package:bausch/sections/order_registration/address_select_screen.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_container.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_widget.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DeliveryAddressSection extends StatefulWidget {
  const DeliveryAddressSection({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressSection> createState() => _DeliveryAddressSectionState();
}

class _DeliveryAddressSectionState extends State<DeliveryAddressSection> {
  final adressesCubit = AdressesCubit();

  late OrderRegistrationScreenWM wm;

  @override
  void initState() {
    super.initState();

    wm = Provider.of<OrderRegistrationScreenWM>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Адрес доставки',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 20,
        ),

        BlocBuilder<AdressesCubit, AdressesState>(
          bloc: adressesCubit,
          builder: (context, state) {
            if (state is GetAdressesSuccess) {
              final adressModel = state.adresses.first;
              wm.address = adressModel;
              wm.adressesCubit = adressesCubit;
              return OrderButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  '/address_select',
                  arguments: AddressSelectScreenArguments(
                    userAdresses: state.adresses,
                    productItemModel: wm.productItemModel,
                    orderRegistrationScreenWM: wm,
                  ),
                ),
                title: Flexible(
                  child: Text(
                    '${adressModel.city}, ${adressModel.street}, ${adressModel.house}',
                    style: AppStyles.h2Bold,
                  ),
                ),
                icon: Icons.check_circle_sharp,
                margin: const EdgeInsets.only(bottom: 4),
              );
            }
            return const AnimatedLoader();
          },
        ),

        OrderButton(
          onPressed: wm.addAddressAction,
          title: Text(
            'Добавить новый адрес',
            style: AppStyles.h2Bold,
          ),
          icon: Icons.add_circle_outline,
          margin: const EdgeInsets.only(bottom: 4),
        ),

        //* "Доставка может занять 60 рабочих дней"
        const DeliveryInfoContainer(),
        const SizedBox(
          height: 4,
        ),

        //* Информация о условиях доставки мелким шрифтом
        const DeliveryInfoWidget(),
      ],
    );
  }
}

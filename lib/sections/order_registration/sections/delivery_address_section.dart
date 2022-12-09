import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
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
import 'package:surf_mwwm/surf_mwwm.dart';

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

    wm.adressesCubit = adressesCubit;
  }

  @override
  void dispose() {
    super.dispose();
    wm.adressesCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdressesCubit, AdressesState>(
      bloc: adressesCubit,
      listener: (context, state) {
        if (state is GetAdressesSuccess) {
          if (state.adresses.isNotEmpty) {
            final adressModel = state.adresses.first;
            wm.address.accept(adressModel);
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
                if (state.adresses.isNotEmpty) {
                  // final adressModel = state.adresses.last;
                  // wm.address.accept(adressModel);

                  return StreamedStateBuilder<AdressModel?>(
                    streamedState: wm.address,
                    builder: (_, selectedAddress) {
                      if (selectedAddress != null) {
                        return OrderButton(
                          onPressed: () async {
                            final address =
                                await Navigator.of(context).pushNamed(
                              '/address_select',
                              arguments: AddressSelectScreenArguments(
                                userAdresses: state.adresses,
                                productItemModel: wm.productItemModel,
                                orderRegistrationScreenWM: wm,
                              ),
                            );

                            address as AdressModel?;

                            if (address != null) {
                              await wm.address.accept(address);
                            }
                          },
                          title: Text(
                            '${selectedAddress.cityAndSettlement}, ${selectedAddress.street}, д ${selectedAddress.house}',
                            style: AppStyles.h2Bold,
                          ),
                          icon: Icons.check_circle_sharp,
                          margin: const EdgeInsets.only(bottom: 4),
                        );
                      }

                      return const SizedBox();
                    },
                  );
                } else {
                  return Container();
                }
              }
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: AnimatedLoader(),
                ),
              );
            },
          ),

          OrderButton(
            onPressed: (){
              AppsflyerSingleton.sdk.logEvent('freePackAddressAdd', null);
              AppMetrica.reportEventWithMap('freePackAddressAdd', null);
              wm.addAddressAction();
            },
            title: const Text(
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
      ),
    );
  }
}

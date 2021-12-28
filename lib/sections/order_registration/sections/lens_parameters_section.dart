import 'package:bausch/models/catalog_item/specification/specification_model.dart';
import 'package:bausch/models/catalog_item/specification/specifications_model.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/order_registration/widgets/single_picker_screen.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_parameters_buttons_section.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class LensParametersSection extends StatefulWidget {
  const LensParametersSection({Key? key}) : super(key: key);

  @override
  State<LensParametersSection> createState() => _LensParametersSectionState();
}

class _LensParametersSectionState extends State<LensParametersSection> {
  //late LensBloc lensBloc;
  late OrderRegistrationScreenWM orderRegistrationScreenWM;
  late SpecificationsModel? specificationModel;

  @override
  void initState() {
    super.initState();
    //lensBloc = BlocProvider.of<LensBloc>(context);
    orderRegistrationScreenWM =
        Provider.of<OrderRegistrationScreenWM>(context, listen: false);
    specificationModel =
        orderRegistrationScreenWM.productItemModel.specifications;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Text(
            'Параметры',
            style: AppStyles.h1,
          ),
        ),
        Column(
          children: [
            if (specificationModel!.diopters != null)
              StreamedStateBuilder<String?>(
                streamedState: orderRegistrationScreenWM.diopters,
                builder: (_, diopters) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4,
                    ),
                    child: FocusButton(
                      labelText: 'Диоптрии',
                      selectedText: diopters,
                      onPressed: () async {
                        await orderRegistrationScreenWM.diopters.accept(
                          await showModalBottomSheet<String?>(
                                context: context,
                                builder: (context) {
                                  return SinglePickerScreen(
                                    title: 'Диоптрий',
                                    variants: orderRegistrationScreenWM
                                        .productItemModel
                                        .specifications!
                                        .diopters!,
                                  );
                                },
                                barrierColor: Colors.black.withOpacity(0.8),
                              ) ??
                              diopters,
                        );
                      },
                    ),
                  );
                },
              ),
            if (specificationModel!.cylinder != null)
              StreamedStateBuilder<String?>(
                streamedState: orderRegistrationScreenWM.cylinder,
                builder: (_, cyl) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Цилиндр',
                      selectedText: cyl,
                      onPressed: () async {
                        await orderRegistrationScreenWM.cylinder
                            .accept(await showModalBottomSheet<String?>(
                                  context: context,
                                  builder: (context) {
                                    return SinglePickerScreen(
                                      title: 'Цилиндр',
                                      variants: specificationModel!.cylinder!,
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                cyl);
                      },
                    ),
                  );
                },
              ),
            if (specificationModel!.axis != null)
              StreamedStateBuilder<String?>(
                streamedState: orderRegistrationScreenWM.axis,
                builder: (_, axis) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Ось',
                      selectedText: axis,
                      onPressed: () async {
                        await orderRegistrationScreenWM.axis
                            .accept(await showModalBottomSheet<String?>(
                                  context: context,
                                  builder: (context) {
                                    return SinglePickerScreen(
                                      title: 'Ось',
                                      variants: specificationModel!.axis!,
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                axis);
                      },
                    ),
                  );
                },
              ),
            if (specificationModel!.addiction != null)
              StreamedStateBuilder<String?>(
                streamedState: orderRegistrationScreenWM.addidations,
                builder: (_, addidations) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Аддидация',
                      selectedText: addidations,
                      onPressed: () async {
                        await orderRegistrationScreenWM.addidations
                            .accept(await showModalBottomSheet<String?>(
                                  context: context,
                                  builder: (context) {
                                    return SinglePickerScreen(
                                      title: 'Аддидация',
                                      variants: specificationModel!.addiction!,
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                addidations);
                      },
                    ),
                  );
                },
              ),
            if (specificationModel!.color != null)
              StreamedStateBuilder<String?>(
                streamedState: orderRegistrationScreenWM.color,
                builder: (_, color) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Цвет',
                      selectedText: color,
                      onPressed: () async {
                        await orderRegistrationScreenWM.color
                            .accept(await showModalBottomSheet<String?>(
                                  context: context,
                                  builder: (context) {
                                    return SinglePickerScreen(
                                      title: 'Цвет',
                                      variants: specificationModel!.color!,
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                color);
                      },
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }
}

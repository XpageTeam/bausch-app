import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_parameters_buttons_section.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LensParametersSection extends StatefulWidget {
  const LensParametersSection({Key? key}) : super(key: key);

  @override
  State<LensParametersSection> createState() => _LensParametersSectionState();
}

class _LensParametersSectionState extends State<LensParametersSection> {
  late LensBloc lensBloc;

  @override
  void initState() {
    super.initState();
    lensBloc = BlocProvider.of<LensBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LensBloc, LensState>(
      bloc: lensBloc,
      builder: (context, state) {
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
            const LensParametersButtonsSection(),
            const SizedBox(
              height: 36,
            ),
          ],
        );
      },
    );
  }
}

import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_listener.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_parameters_content.dart';
import 'package:bausch/sections/profile/profile_settings/picker_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/pages/error_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* Profile
/// Параметры линз
class LensesParametersScreen extends StatefulWidget {
  const LensesParametersScreen({Key? key}) : super(key: key);

  @override
  State<LensesParametersScreen> createState() => _LensesParametersScreenState();
}

class _LensesParametersScreenState extends State<LensesParametersScreen> {
  final LensBloc lensBloc = LensBloc();

  @override
  void dispose() {
    super.dispose();
    lensBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => lensBloc,
      child: LensListener(
        child: BlocBuilder<LensBloc, LensState>(
          builder: (context, state) {
            return LensParametersContent();
          },
        ),
      ),
    );
  }
}

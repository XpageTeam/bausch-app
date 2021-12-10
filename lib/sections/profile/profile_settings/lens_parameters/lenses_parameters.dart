import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_listener.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_parameters_content.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//* Profile
/// Параметры линз
class LensesParametersScreen extends StatefulWidget {
  const LensesParametersScreen({Key? key}) : super(key: key);

  @override
  State<LensesParametersScreen> createState() => _LensesParametersScreenState();
}

class _LensesParametersScreenState extends State<LensesParametersScreen> {
  //late LensBloc lensBloc;
  //final GetLensCubit getLensCubit = GetLensCubit();

  @override
  void initState() {
    super.initState();
    //lensBloc =
  }

  @override
  void dispose() {
    super.dispose();
    //lensBloc.close();
    //getLensCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return const LensProvider(
      child: LensListener(
        child: LensParametersContent(),
      ),
    );
  }
}

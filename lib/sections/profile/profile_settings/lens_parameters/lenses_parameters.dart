import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/picker_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
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
  void initState() {
    super.initState();
    lensBloc.add(LensGet());
  }

  @override
  void dispose() {
    super.dispose();
    lensBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        title: 'Параметры линз',
        backgroundColor: AppTheme.mystic,
      ),
      body: BlocBuilder<LensBloc, LensState>(
        bloc: lensBloc,
        builder: (context, state) {
          debugPrint(state.toString());
          if (state is LensGotten) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 4,
                    ),
                    child: FocusButton(
                      labelText: 'Диоптрии',
                      selectedText: '${state.model.diopter}',
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (context) {
                            return const PickerScreen();
                          },
                          barrierColor: Colors.black.withOpacity(0.8),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Цилиндр',
                      selectedText: '${state.model.cylinder}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Ось',
                      selectedText: '${state.model.axis}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FocusButton(
                      labelText: 'Аддидация',
                      selectedText: '${state.model.addict}',
                    ),
                  ),
                ],
              ),
            );
          }
          return AnimatedLoader();
        },
      ),
    );
  }
}

import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_listener.dart';
import 'package:bausch/sections/profile/profile_settings/picker_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/pages/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LensParametersContent extends StatefulWidget {
  const LensParametersContent({Key? key}) : super(key: key);

  @override
  _LensParametersScreenState createState() => _LensParametersScreenState();
}

class _LensParametersScreenState extends State<LensParametersContent> {
  late LensBloc lensBloc;

  @override
  void initState() {
    super.initState();

    lensBloc = BlocProvider.of<LensBloc>(context);
    lensBloc.add(LensGet());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LensBloc, LensState>(
      //bloc: lensBloc,
      builder: (context, state) {
        debugPrint(state.toString());

        if (state is LensGetFailed) {
          return ErrorPage(
            title: state.title,
            subtitle: state.subtitle,
            buttonText: 'Обновить',
            buttonCallback: () {
              lensBloc.add(LensGet());
            },
          );
        }

        if ((state is LensLoading) || (state is LensGetting)) {
          return const Scaffold(
            body: Center(
              child: AnimatedLoader(),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppTheme.mystic,
          appBar: const DefaultAppBar(
            title: 'Параметры линз',
            backgroundColor: AppTheme.mystic,
          ),
          body: Padding(
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
                    onPressed: () async {
                      lensBloc.add(
                        LensUpdate(
                          model: LensParametersModel(
                            addict: state.model.addict,
                            cylinder: state.model.cylinder,
                            axis: state.model.axis,
                            diopter: await showModalBottomSheet<int>(
                                  context: context,
                                  builder: (context) {
                                    return const PickerScreen(
                                      title: 'Диоптрий',
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                state.model.diopter,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: FocusButton(
                    labelText: 'Цилиндр',
                    selectedText: '${state.model.cylinder}',
                    onPressed: () async {
                      lensBloc.add(
                        LensUpdate(
                          model: LensParametersModel(
                            addict: state.model.addict,
                            cylinder: await showModalBottomSheet<int>(
                                  context: context,
                                  builder: (context) {
                                    return const PickerScreen(
                                      title: 'Цилиндр',
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                state.model.cylinder,
                            axis: state.model.axis,
                            diopter: state.model.diopter,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: FocusButton(
                    labelText: 'Ось',
                    selectedText: '${state.model.axis}',
                    onPressed: () async {
                      lensBloc.add(
                        LensUpdate(
                          model: LensParametersModel(
                            addict: state.model.addict,
                            cylinder: state.model.cylinder,
                            axis: await showModalBottomSheet<int>(
                                  context: context,
                                  builder: (context) {
                                    return const PickerScreen(
                                      title: 'Ось',
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                state.model.axis,
                            diopter: state.model.diopter,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: FocusButton(
                    labelText: 'Аддидация',
                    selectedText: '${state.model.addict}',
                    onPressed: () async {
                      lensBloc.add(
                        LensUpdate(
                          model: LensParametersModel(
                            addict: await showModalBottomSheet<int>(
                                  context: context,
                                  builder: (context) {
                                    return const PickerScreen(
                                      title: 'Аддидация',
                                    );
                                  },
                                  barrierColor: Colors.black.withOpacity(0.8),
                                ) ??
                                state.model.addict,
                            cylinder: state.model.cylinder,
                            axis: state.model.axis,
                            diopter: state.model.diopter,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: BlueButtonWithText(
                    text: 'Добавить',
                    onPressed: () {
                      lensBloc.add(LensSend(model: lensBloc.state.model));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

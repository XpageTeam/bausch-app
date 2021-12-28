import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/picker_screen.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LensParametersButtonsSection extends StatefulWidget {
  const LensParametersButtonsSection({Key? key}) : super(key: key);

  @override
  State<LensParametersButtonsSection> createState() =>
      _LensParametersButtonsSectionState();
}

class _LensParametersButtonsSectionState
    extends State<LensParametersButtonsSection> {
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
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: FocusButton(
                labelText: 'Диоптрии',
                selectedText: lensBloc.state.model.diopter != 0
                    ? '${lensBloc.state.model.diopter}'
                    : null,
                onPressed: () async {
                  lensBloc.add(
                    LensUpdate(
                      model: LensParametersModel(
                        addict: lensBloc.state.model.addict,
                        cylinder: lensBloc.state.model.cylinder,
                        axis: lensBloc.state.model.axis,
                        diopter: await showModalBottomSheet<num>(
                              context: context,
                              builder: (context) {
                                return const PickerScreen(
                                  title: 'Диоптрий',
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            lensBloc.state.model.diopter,
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
                selectedText: lensBloc.state.model.cylinder != 0
                    ? '${lensBloc.state.model.cylinder}'
                    : null,
                onPressed: () async {
                  lensBloc.add(
                    LensUpdate(
                      model: LensParametersModel(
                        addict: lensBloc.state.model.addict,
                        cylinder: await showModalBottomSheet<num>(
                              context: context,
                              builder: (context) {
                                return const PickerScreen(
                                  title: 'Цилиндр',
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            lensBloc.state.model.cylinder,
                        axis: lensBloc.state.model.axis,
                        diopter: lensBloc.state.model.diopter,
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
                selectedText: lensBloc.state.model.axis != 0
                    ? '${lensBloc.state.model.axis}'
                    : null,
                onPressed: () async {
                  lensBloc.add(
                    LensUpdate(
                      model: LensParametersModel(
                        addict: lensBloc.state.model.addict,
                        cylinder: lensBloc.state.model.cylinder,
                        axis: await showModalBottomSheet<num>(
                              context: context,
                              builder: (context) {
                                return const PickerScreen(
                                  title: 'Ось',
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            lensBloc.state.model.axis,
                        diopter: lensBloc.state.model.diopter,
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
                selectedText: lensBloc.state.model.addict != 0
                    ? '${lensBloc.state.model.addict}'
                    : null,
                onPressed: () async {
                  lensBloc.add(
                    LensUpdate(
                      model: LensParametersModel(
                        addict: await showModalBottomSheet<num>(
                              context: context,
                              builder: (context) {
                                return const PickerScreen(
                                  title: 'Аддидация',
                                );
                              },
                              barrierColor: Colors.black.withOpacity(0.8),
                            ) ??
                            lensBloc.state.model.addict,
                        cylinder: lensBloc.state.model.cylinder,
                        axis: lensBloc.state.model.axis,
                        diopter: lensBloc.state.model.diopter,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

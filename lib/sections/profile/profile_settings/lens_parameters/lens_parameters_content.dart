import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_parameters_buttons_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
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
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              30,
              StaticData.sidePadding,
              0,
            ),
            child: Column(
              children: [
                LensParametersButtonsSection(),
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

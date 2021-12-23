import 'dart:core';

import 'package:bausch/sections/sheets/screens/add_points/bloc/add_points_code/add_points_code_bloc.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeSection extends StatefulWidget {
  const CodeSection({Key? key}) : super(key: key);

  @override
  _CodeSectionState createState() => _CodeSectionState();
}

class _CodeSectionState extends State<CodeSection> {
  final addPointsCodeBloc = AddPointsCodeBloc();
  TextEditingController codeController = TextEditingController();
  List<String> items = ['Раствор', 'Линзы', 'Еще что-то'];
  String _value = 'Продукт';

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 14,
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: BlocBuilder<AddPointsCodeBloc, AddPointsCodeState>(
        bloc: addPointsCodeBloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ввести код с упаковки',
                style: AppStyles.h1,
              ),
              const SizedBox(
                height: 20,
              ),
              NativeTextInput(
                labelText: 'Код',
                controller: codeController,
                backgroundColor: AppTheme.mystic,
              ),
              const SizedBox(
                height: 4,
              ),
              if (state is AddPointsCodeGetSuccess)
                SelectButton(
                  value: _value,
                  color: AppTheme.mystic,
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text('Продукт'),
                        actions: List.generate(
                          state.models.length,
                          (i) {
                            return CupertinoActionSheetAction(
                              onPressed: () {
                                setState(() {
                                  _value = state.models[i].title;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text(state.models[i].title),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              else
                SelectButton(
                  value: _value,
                  color: AppTheme.mystic,
                ),
              const SizedBox(
                height: 4,
              ),
              BlueButtonWithText(
                text: 'Добавить баллы',
                icon: const Icon(
                  Icons.add,
                  color: AppTheme.mineShaft,
                ),
                onPressed: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

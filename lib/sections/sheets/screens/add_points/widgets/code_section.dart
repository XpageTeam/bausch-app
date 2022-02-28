import 'dart:core';

import 'package:bausch/models/add_points/product_code_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/bloc/add_points_code/add_points_code_bloc.dart';
import 'package:bausch/sections/sheets/screens/add_points/final_add_points.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeSection extends StatefulWidget {
  const CodeSection({Key? key}) : super(key: key);

  @override
  _CodeSectionState createState() => _CodeSectionState();
}

class _CodeSectionState extends State<CodeSection> {
  final addPointsCodeBloc = AddPointsCodeBloc();
  TextEditingController codeController = TextEditingController();
  ProductCodeModel? _value;

  @override
  void initState() {
    super.initState();

    codeController.addListener(() {
      setState(() {
        addPointsCodeBloc.add(
          AddPointsCodeUpdateCode(
            code: codeController.text,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
    addPointsCodeBloc.close();
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
      child: BlocProvider(
        create: (context) => addPointsCodeBloc,
        child: BlocListener<AddPointsCodeBloc, AddPointsCodeState>(
          listener: (context, state) {
            if (state is AddPointsCodeFailed) {
              showDefaultNotification(title: state.title);
            }
            if (state is AddPointsCodeSendSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/final_addpoints',
                (route) => route.isCurrent,
                arguments: FinalAddPointsArguments(
                  points: state.points.toString(),
                ),
              );
            }
          },
          child: BlocBuilder<AddPointsCodeBloc, AddPointsCodeState>(
            builder: (context, state) {
              debugPrint(state.toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
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
                  SelectButton(
                    value: _value != null ? _value!.title : 'Продукт',
                    color: AppTheme.mystic,
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: const Text(
                            'Продукт',
                            style: AppStyles.p1,
                          ),
                          actions: List.generate(
                            state.models.length,
                            (i) {
                              return CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    _value = state.models[i];
                                  });
                                  addPointsCodeBloc.add(
                                    AddPointsCodeUpdateProduct(
                                      product: state.models[i].code.toString(),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  state.models[i].title,
                                  style: AppStyles.h2,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
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
                    onPressed:
                        (state.code.isNotEmpty) && (state.product.isNotEmpty)
                            ? () {
                                addPointsCodeBloc.add(
                                  AddPointsCodeSend(
                                    code: state.code,
                                    productId: state.product,
                                  ),
                                );
                              }
                            : () {
                                showDefaultNotification(
                                  title: 'Введите код и выберите продукт',
                                );
                              },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

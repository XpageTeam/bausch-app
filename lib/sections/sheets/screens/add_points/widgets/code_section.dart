import 'dart:async';
import 'dart:core';

import 'package:bausch/models/add_points/product_code_model.dart';
import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/requesters/choose_lenses_requester.dart';
import 'package:bausch/sections/sheets/screens/add_points/bloc/add_points_code/add_points_code_bloc.dart';
import 'package:bausch/sections/sheets/screens/add_points/final_add_points.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeSection extends StatefulWidget {
  final MyLensesWM? myLensesWM;
  const CodeSection({required this.myLensesWM, Key? key}) : super(key: key);

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
          listener: (context, state) async {
            if (state is AddPointsCodeFailed) {
              showDefaultNotification(title: state.title);
            }
            if (state is AddPointsCodeSendSuccess) {
              LensProductModel? productBausch;
              for (final product
                  in (await ChooseLensesRequester().loadLensProducts())
                      .products) {
                if (product.bauschProductId != null &&
                    _value != null &&
                    product.bauschProductId == _value!.id) {
                  productBausch = product;
                }
              }
              // TODO(pavlov): тут передаю id продукта линз если выбраны линзы
              // ignore: use_build_context_synchronously
              unawaited(Navigator.of(context).pushNamedAndRemoveUntil(
                '/final_addpoints',
                (route) => route.isCurrent,
                arguments: FinalAddPointsArguments(
                  points: state.points.toString(),
                  productBausch: productBausch,
                  myLensesWM: widget.myLensesWM,
                ),
              ));
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
                        builder: (context) => ScrollConfiguration(
                          behavior: const AntiGlowBehavior(),
                          child: BlocProvider.value(
                            value: addPointsCodeBloc,
                            child: BlocBuilder<AddPointsCodeBloc,
                                AddPointsCodeState>(
                              builder: (context, state) {
                                return CupertinoActionSheet(
                                  title: const Text(
                                    'Продукт',
                                    style: AppStyles.p1,
                                  ),
                                  actions: state is AddPointsCodeLoading
                                      ? [
                                          const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: AnimatedLoader(),
                                            ),
                                          ),
                                        ]
                                      : state is AddPointsCodeFailed
                                          ? [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    16.0,
                                                  ),
                                                  child: BlueButtonWithText(
                                                    text: 'Повторить',
                                                    onPressed: () =>
                                                        addPointsCodeBloc.add(
                                                      AddPointsCodeGet(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
                                          : List.generate(
                                              state.models.length,
                                              (i) {
                                                return CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    setState(() {
                                                      _value = state.models[i];
                                                    });
                                                    addPointsCodeBloc.add(
                                                      AddPointsCodeUpdateProduct(
                                                        product: state
                                                            .models[i].code
                                                            .toString(),
                                                        productName: state
                                                            .models[i].title,
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
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  BlueButtonWithText(
                    text: 'Накопить баллы',
                    icon: Icon(
                      Icons.add,
                      color: state.code.isNotEmpty &&
                              state.product.isNotEmpty &&
                              state is! AddPointsCodeLoading
                          ? AppTheme.mineShaft
                          : AppTheme.mineShaft.withOpacity(0.5),
                    ),
                    onPressed: state is! AddPointsCodeLoading &&
                            (state.code.isNotEmpty) &&
                            (state.product.isNotEmpty)
                        ? () {
                            addPointsCodeBloc.add(
                              AddPointsCodeSend(
                                code: state.code,
                                productId: state.product,
                                productName: state.productName,
                              ),
                            );
                          }
                        : null,
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

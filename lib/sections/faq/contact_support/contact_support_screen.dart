import 'package:bausch/models/faq/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/extra_forms_section.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactSupportScreenArguments {
  final int? questionId;
  final int? topicId;

  ContactSupportScreenArguments({this.questionId, this.topicId});
}

class ContactSupportScreen extends StatefulWidget
    implements ContactSupportScreenArguments {
  final ScrollController controller;
  @override
  final int? questionId;
  @override
  final int? topicId;

  const ContactSupportScreen({
    required this.controller,
    this.questionId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final FormsCubit formsCubit = FormsCubit();
  final FieldsBloc fieldsBloc = FieldsBloc();
  //late FormsExtraCubit formsExtraCubit = FormsExtraCubit(id: widget.id);
  TextEditingController emailController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String selectedCategory = '';
  String selectedTheme = '';

  @override
  void dispose() {
    super.dispose();

    formsCubit.close();

    emailController.dispose();
    commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Question: ${widget.questionId}, topic: ${widget.topicId}');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: BlocBuilder<FieldsBloc, FieldsState>(
        bloc: fieldsBloc,
        builder: (context, fieldState) {
          return Scaffold(
            backgroundColor: AppTheme.mystic,
            resizeToAvoidBottomInset: false,
            body: CustomScrollView(
              controller: widget.controller,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 14,
                          bottom: 30,
                        ),
                        child: DefaultAppBar(
                          title: 'Написать в поддержку',
                          backgroundColor: AppTheme.mystic,
                          topRightWidget: NormalIconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Keys.mainNav.currentState!.pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                  ),
                  sliver: BlocBuilder<FormsCubit, FormsState>(
                    bloc: formsCubit,
                    builder: (context, state) {
                      if (state is FormsSuccess) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              return childBuilder(state.fields[i]);
                            },
                            childCount: state.fields.length,
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const AnimatedLoader(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: StaticData.sidePadding,
                //   ),
                //   sliver: BlocBuilder<FormsExtraCubit, FormsExtraState>(
                //     bloc: formsExtraCubit,
                //     builder: (context, state) {
                //       if (state is FormsExtraSuccess) {
                //         return SliverList(
                //           delegate: SliverChildBuilderDelegate(
                //             (context, i) {
                //               return childBuilder(state.fields[i]);
                //             },
                //             childCount: state.fields.length,
                //           ),
                //         );
                //       }
                //       return SliverList(
                //         delegate: SliverChildListDelegate(
                //           [
                //             const AnimatedLoader(),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
                if (widget.questionId != null)
                  ExtraFormsSection(id: widget.questionId!),
              ],
            ),
            floatingActionButton: const Padding(
              padding: EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
              child: BlueButtonWithText(text: 'Отправить'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  Widget childBuilder(FieldModel model) {
    var _value = model.name;
    if (model.type == 'select') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: SelectButton(
          value: _value,
          color: Colors.white,
          onPressed: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text(model.name),
                actions: model.values!
                    .map(
                      (e) => CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            _value = e;
                          });
                          Navigator.of(context).pop();
                          debugPrint(_value);
                        },
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: DefaultTextInput(
          labelText: model.name,
          controller: TextEditingController(),
          inputType: TextInputType.emailAddress,
        ),
      );
    }
  }
}

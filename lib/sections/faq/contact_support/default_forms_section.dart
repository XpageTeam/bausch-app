import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultFormsSection extends StatefulWidget {
  const DefaultFormsSection({Key? key}) : super(key: key);

  @override
  State<DefaultFormsSection> createState() => _DefaultFormsSectionState();
}

class _DefaultFormsSectionState extends State<DefaultFormsSection> {
  final FormsCubit formsCubit = FormsCubit();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
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
                  if (state.fields[i].type == 'select') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SelectButton(
                        value: state.fields[i].name,
                        color: Colors.white,
                        onPressed: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              title: Text(state.fields[i].name),
                              actions: state.fields[i].values!
                                  .map(
                                    (e) => CupertinoActionSheetAction(
                                      onPressed: () {},
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
                        labelText: state.fields[i].name,
                        controller: TextEditingController(),
                        inputType: TextInputType.emailAddress,
                      ),
                    );
                  }
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
    );
  }
}

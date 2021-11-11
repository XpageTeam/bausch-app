import 'package:bausch/sections/faq/contact_support/form_builder.dart';
import 'package:bausch/sections/faq/cubit/forms_extra/forms_extra_cubit.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/select_button.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtraFormsSection extends StatefulWidget {
  final int id;
  const ExtraFormsSection({required this.id, Key? key}) : super(key: key);

  @override
  _ExtraFormsSectionState createState() => _ExtraFormsSectionState();
}

class _ExtraFormsSectionState extends State<ExtraFormsSection> {
  late FormsExtraCubit formsExtraCubit = FormsExtraCubit(id: widget.id);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: BlocBuilder<FormsExtraCubit, FormsExtraState>(
        bloc: formsExtraCubit,
        builder: (context, state) {
          if (state is FormsExtraSuccess) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return childBuilder(state.fields[i], context);
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

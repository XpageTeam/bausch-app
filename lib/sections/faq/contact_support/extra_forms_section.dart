import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/bloc/forms_extra/forms_extra_bloc.dart';
import 'package:bausch/sections/faq/contact_support/form_builder.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtraFormsSection extends StatefulWidget {
  //final int id;
  const ExtraFormsSection({Key? key}) : super(key: key);

  @override
  _ExtraFormsSectionState createState() => _ExtraFormsSectionState();
}

class _ExtraFormsSectionState extends State<ExtraFormsSection> {
  late FormsExtraBloc formsExtraBloc;
  late FieldsBloc fieldsBloc;

  @override
  void initState() {
    super.initState();

    fieldsBloc = BlocProvider.of<FieldsBloc>(context);
    formsExtraBloc = BlocProvider.of<FormsExtraBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    fieldsBloc.close();
    formsExtraBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: BlocBuilder<FormsExtraBloc, FormsExtraState>(
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
                Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}

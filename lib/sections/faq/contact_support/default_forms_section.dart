import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/form_builder.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';

import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultFormsSection extends StatelessWidget {
  final List<FieldModel> defaultFields;

  const DefaultFormsSection({
    required this.defaultFields,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            return childBuilder(
              defaultFields[i],
              context,
            );
          },
          childCount: defaultFields.length,
        ),
      ),
    );
  }
}

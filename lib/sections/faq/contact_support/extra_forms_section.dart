import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/contact_support/form_builder.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExtraFormsSection extends StatelessWidget {
  final List<FieldModel> exrtaFields;
  const ExtraFormsSection({required this.exrtaFields, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            return childBuilder(exrtaFields[i], context);
          },
          childCount: exrtaFields.length,
        ),
      ),
    );
  }
}

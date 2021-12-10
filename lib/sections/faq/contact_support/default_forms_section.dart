import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/faq/contact_support/form_builder.dart';
import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultFormsSection extends StatefulWidget {
  //final ContactSupportScreenArguments? arguments;
  final int? topic;
  final int? question;
  const DefaultFormsSection({
    this.topic,
    this.question,
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultFormsSection> createState() => _DefaultFormsSectionState();
}

class _DefaultFormsSectionState extends State<DefaultFormsSection> {
  late FormsCubit formsCubit;
  late FieldsBloc fieldsBloc;

  @override
  void initState() {
    super.initState();

    fieldsBloc = BlocProvider.of<FieldsBloc>(context);

    formsCubit = BlocProvider.of<FormsCubit>(context);

    if (widget.question != null) {
      fieldsBloc.add(FieldsSetQuestion(widget.question!));
    }

    if (widget.topic != null) {
      fieldsBloc.add(FieldsSetTopic(widget.topic!));
    }
  }

  @override
  void dispose() {
    super.dispose();
    fieldsBloc.close();
    formsCubit.close();
  }

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
                  return childBuilder(
                    state.fields[i],
                    context,
                  );
                },
                childCount: state.fields.length,
              ),
            );
          }
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                const Center(child: AnimatedLoader()),
              ],
            ),
          );
        },
      ),
    );
  }
}

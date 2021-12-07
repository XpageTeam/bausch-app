import 'package:bausch/sections/faq/cubit/forms/forms_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/select_widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactSupportScreen extends StatefulWidget {
  final ScrollController controller;
  const ContactSupportScreen({required this.controller, Key? key})
      : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final FormsCubit formsCubit = FormsCubit();
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
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
                          debugPrint(i.toString());
                          if (state.fields[i].type == 'select') {
                            return DropdownWidget(
                              items: state.fields[i].values!,
                              onItemSelected: (s) {
                                setState(() {
                                  selectedCategory = s;
                                });
                              },
                              labeltext: state.fields[i].name,
                              selectedKey: selectedCategory,
                              backgroundColor: Colors.white,
                              cornersColor: AppTheme.mystic,
                            );
                          } else {
                            return NativeTextInput(
                              labelText: state.fields[i].name,
                              controller: emailController,
                              inputType: TextInputType.emailAddress,
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
                        Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

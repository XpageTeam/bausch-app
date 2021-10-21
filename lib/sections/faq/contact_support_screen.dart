import 'package:bausch/sections/sheets/screens/add_points/widgets/dropdown_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatefulWidget {
  final ScrollController controller;
  const ContactSupportScreen({required this.controller, Key? key})
      : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String selectedCategory = '';
  String selectedTheme = '';

  @override
  void dispose() {
    super.dispose();

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
                        icon: Icon(Icons.close),
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
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    DefaultTextInput(
                      labelText: 'E-mail',
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    DropdownWidget(
                      items: ['as', 'adsd'],
                      onItemSelected: (s) {
                        setState(() {
                          selectedCategory = s;
                        });
                      },
                      labeltext: 'Категория',
                      selectedKey: selectedCategory,
                      backgroundColor: Colors.white,
                      cornersColor: AppTheme.mystic,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    DropdownWidget(
                      items: ['as', 'adsd'],
                      onItemSelected: (s) {
                        setState(() {
                          selectedTheme = s;
                        });
                      },
                      labeltext: 'Тема',
                      selectedKey: selectedTheme,
                      backgroundColor: Colors.white,
                      cornersColor: AppTheme.mystic,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    DefaultTextInput(
                      labelText: 'Ваш комметарий',
                      controller: commentController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/home/widgets/listeners/text_buttons_listener.dart';
import 'package:bausch/widgets/buttons/white_button_with_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteToSupportButton extends StatefulWidget {
  const WriteToSupportButton({super.key});

  @override
  State<WriteToSupportButton> createState() => _WriteToSupportButtonState();
}

class _WriteToSupportButtonState extends State<WriteToSupportButton> {
  final faqCubit = FaqCubit();

  @override
  void dispose() {
    faqCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: faqCubit,
      child: TextButtonsListener(
        onlyFaqListener: true,
        child: WhiteButtonWithText(
          text: 'Написать в поддержку',
          onPressed: () {
            FirebaseAnalytics.instance.logEvent(
              name: 'support_button_click',
            );
            faqCubit.loadData();
          },
        ),
      ),
    );
  }
}

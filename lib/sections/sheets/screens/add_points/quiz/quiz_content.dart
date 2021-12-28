import 'package:bausch/models/add_points/quiz/quiz_content_model.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class QuizContent extends StatefulWidget {
  final QuizContentModel model;
  const QuizContent({required this.model, Key? key}) : super(key: key);

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 4,
          ),
          child: Text(
            widget.model.title,
            style: AppStyles.h2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
          ),
          child: Text(
            '1/10',
            style: AppStyles.h3,
          ),
        ),
        Column(
          children: List.generate(3, (i) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                  right: 12,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.model.answers[i].title,
                        style: AppStyles.h3,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomRadio(
                      value: i,
                      groupValue: _selected,
                      onChanged: (v) {
                        setState(
                          () {
                            _selected = i;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/models/faq/forms/value_model.dart';
import 'package:bausch/sections/faq/contact_support/select.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Блок с выбором темы и вопроса
class TopicQuestionSelect extends StatefulWidget {
  const TopicQuestionSelect({Key? key}) : super(key: key);

  @override
  State<TopicQuestionSelect> createState() => _TopicQuestionSelectState();
}

class _TopicQuestionSelectState extends State<TopicQuestionSelect> {
  late final FormScreenWM formScreenWM;

  @override
  void initState() {
    super.initState();
    formScreenWM = Provider.of<FormScreenWM>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    formScreenWM.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            EntityStateBuilder<List<ValueModel>>(
              streamedState: formScreenWM.topicsList,
              loadingChild: const SizedBox(),
              errorChild: Text(formScreenWM.topicsList.value.error.toString()),
              builder: (_, state) {
                return Select(
                  state: formScreenWM.selectedTopic,
                  model: FieldModel(
                    id: 0,
                    name: 'Категория',
                    type: 'select',
                    xmlId: 'topic',
                    values: state,
                  ),
                );
              },
            ),
            EntityStateBuilder<List<ValueModel>>(
              streamedState: formScreenWM.questionsList,
              builder: (_, state) {
                return Select(
                  state: formScreenWM.selectedQuestion,
                  model: FieldModel(
                    id: 0,
                    name: 'Вопрос',
                    type: 'select',
                    xmlId: 'question',
                    values: state,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

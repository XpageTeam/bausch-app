import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  late UserWM userWM;

  TextEditingController controller = TextEditingController();

  bool confirmSended = false;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    userWM = Provider.of<UserWM>(context, listen: false);
    if ((userWM.userData.value.data!.user.email != null) ||
        (userWM.userData.value.data!.user.email!.isNotEmpty)) {
      controller.text = userWM.userData.value.data!.user.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'E-mail',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 12,
              ),
              child: NativeTextInput(
                labelText: 'E-mail',
                controller: controller,
              ),
            ),
            Text(
              'Для отчёта о баллах',
              style: AppStyles.p1,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: BlueButtonWithText(
          text: confirmSended ? 'Готово' : 'Добавить',
          onPressed: controller.text.isNotEmpty
              ? () {
                  if (confirmSended) {
                    //TODO: Показать уведомление о подтверждении почты
                    Navigator.of(context).pop(controller.text);
                  } else {
                    confirmSended = true;
                    setState(() {});
                  }
                }
              : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

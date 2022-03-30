import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/sections/registration/widgets/code_form/code_form.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key}) : super(key: key);

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginWM = Provider.of<LoginWM>(context);

    return Scaffold(
      backgroundColor: AppTheme.mystic,
      extendBody: true,
      appBar: const DefaultAppBar(
        title: '',
        backgroundColor: Colors.transparent,
      ),
      body: CodeForm(
        wm: loginWM,
      ),
      // floatingActionButton: StreamedStateBuilder<int>(
      //   streamedState: loginWM.smsResendSeconds,
      //   builder: (_, data) {
      //     if (data > 0) {
      //       return Container(
      //         padding: const EdgeInsets.only(
      //           bottom: 20,
      //           //left: StaticData.sidePadding,
      //           right: StaticData.sidePadding,
      //         ),
      //         width: MediaQuery.of(context).size.width,
      //         //Повторная отправка через ${getTimerBySeconds(data)}',
      //         child: RichText(
      //           //textAlign: TextAlign.left,
      //           text: TextSpan(
      //             style: AppStyles.p1,
      //             children: [
      //               const TextSpan(
      //                 text: 'Повторная отправка через',
      //               ),
      //               TextSpan(
      //                 text: ' ${getTimerBySeconds(data)}',
      //                 style: AppStyles.p1.copyWith(
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     } else {
      //       return TextButton(
      //         child: const Text(
      //           'Отправить новый код',
      //           style: AppStyles.h2,
      //         ),
      //         style: TextButton.styleFrom(
      //           padding: EdgeInsets.zero,
      //         ),
      //         onPressed: loginWM.resendSMSAction,
      //       );
      //     }
      //   },
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

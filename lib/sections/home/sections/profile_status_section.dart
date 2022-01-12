import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileStatus extends StatelessWidget {
  const ProfileStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<UserRepository>(
      streamedState: Provider.of<UserWM>(context).userData,
      builder: (_, userData) {
        debugPrint(userData.toString());
        return InkWell(
          onTap: () {
            Keys.mainContentNav.currentState!.pushNamed('/profile');
          },
          child: Row(
            children: [
              // * вроде нужно было это убрать по новому макету
              // const CircleAvatar(
              //   radius: 21,
              //   backgroundColor: AppTheme.turquoiseBlue,
              // ),
              // const SizedBox(
              //   width: 6,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        userData.userName,
                        style: AppStyles.h1,
                      ),
                      // const CircleAvatar(
                      //   radius: 5,
                      //   backgroundColor: AppTheme.turquoiseBlue,
                      // ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: AppTheme.turquoiseBlue,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ],
                  ),
                  //! статус пользователя пока не выводим
                  // Text(
                  //   'Классный друг',
                  //   style: AppStyles.p1,
                  // ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

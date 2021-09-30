import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      color: AppTheme.mystic,
      child: Column(
        children: [
          TextButton(
              onPressed: () {},
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: AppTheme.turquoiseBlue,
                      borderRadius: BorderRadius.circular(5)),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        color: AppTheme.mineShaft,
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        'Добавить баллы',
                        style: AppStyles.h3,
                      ),
                    ],
                  ))),
          const Text(
            'Имеются противопоказания, необходимо проконсультироваться со специалистом',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 16 / 14,
            ),
          )
        ],
      ),
    );
  }
}

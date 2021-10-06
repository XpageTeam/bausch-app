import 'package:bausch/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoriesBottomButtons extends StatelessWidget {
  final String? buttonTitle;

  //тут будет модель товара, из нее подгружается картинка и название
  final String? upperTitle;

  const StoriesBottomButtons({this.buttonTitle, this.upperTitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 101,
            //width: MediaQuery.of(context).size.width - 24,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Text(
                        upperTitle ?? '',
                        style: AppStyles.p1,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      'assets/item.png',
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonTitle ?? 'Участвовать в акции',
                    style: AppStyles.h3,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.add,
                    color: Color(0xFF2D2D2D),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 60,
            child: Center(
              child: Text(
                'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                style: TextStyle(
                  fontSize: 14,
                  height: 16 / 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

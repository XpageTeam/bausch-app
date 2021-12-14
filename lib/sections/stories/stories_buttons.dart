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
                    style: AppStyles.h2,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    'assets/icons/link.png',
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Text(
              'Сроки проведения акции с 01.09.21 по 15.12.21. Информация об организаторе, правилах проведения акции, количестве призов, сроках, месте и порядке их получения доступна на renu.ultralinzi.ru',
              style: AppStyles.n1.copyWith(color: const Color(0xFF797B7C)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 18,
              bottom: 6,
            ),
            child: SizedBox(
              //height: 60,
              child: Center(
                child: Text(
                  'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                  style: TextStyle(
                    fontSize: 14,
                    height: 16 / 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: 'Euclid Circular A',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

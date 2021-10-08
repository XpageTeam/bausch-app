import 'package:bausch/models/story_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  final StoryModel model;
  const Story({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 250,
      width:
          (MediaQuery.of(context).size.width - StaticData.sidePadding * 2) / 3 -
              2.5,
      child: GestureDetector(
        onTap: () {
          debugPrint(model.title);
        },
        child: AspectRatio(
          aspectRatio: 114 / 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Positioned.fill(
                  child: model.img == null
                      ? Image.asset('assets/pic1.png')
                      : Image.asset(model.img!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        style: AppStyles.h2WhiteBold,
                      ),
                      Text(
                        model.number.toString(),
                        style: AppStyles.p1White,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

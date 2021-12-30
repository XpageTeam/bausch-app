import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/stories/stories_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  final StoryModel model;

  //final List<StoryContentModel> models;

  const Story({
    required this.model,
    //required this.models,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width - StaticData.sidePadding * 2) / 3 -
              2.5,
      child: GestureDetector(
        onTap: () {
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return StoriesScreen(
                  storyModel: model,
                );
              },
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 114 / 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    model.content.first.preview,
                    fit: BoxFit.cover,
                  ),
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
                        model.content.first.title,
                        style: AppStyles.h2WhiteBold,
                      ),
                      Text(
                        model.content.length.toString(),
                        style: AppStyles.p1.copyWith(color: Colors.white),
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

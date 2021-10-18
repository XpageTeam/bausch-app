import 'package:bausch/models/story_model.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

class StoriesSlider extends StatelessWidget {
  final List<StoryModel> items;

  const StoriesSlider({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      clipBehavior: Clip.none,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Story(
                    model: item,
                    index: item.index,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

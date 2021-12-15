import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:flutter/material.dart';

class StoriesSlider extends StatefulWidget {
  const StoriesSlider({Key? key}) : super(key: key);

  @override
  State<StoriesSlider> createState() => _StoriesSliderState();
}

class _StoriesSliderState extends State<StoriesSlider> {
  @override
  void dispose() {
    super.dispose();
  }

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
        children: Models.stories
            .map((item) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Story(
                    model: item,
                    models: Models.stories,
                    index: Models.stories.indexOf(item),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

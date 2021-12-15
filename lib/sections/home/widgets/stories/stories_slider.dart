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
    return BlocBuilder<StoriesCubit, StoriesState>(
      bloc: storiesCubit,
      builder: (context, state) {
        if (state is StoriesSuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.sidePadding,
            ),
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.stories
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Story(
                          model: item,
                          models: state
                              .stories[state.stories.indexOf(item)].content,
                        ),
                      ))
                  .toList(),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}

import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/sections/stories/cubit/stories_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoriesSlider extends StatefulWidget {
  const StoriesSlider({Key? key}) : super(key: key);

  @override
  State<StoriesSlider> createState() => _StoriesSliderState();
}

class _StoriesSliderState extends State<StoriesSlider> {
  final StoriesCubit storiesCubit = StoriesCubit();

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
                          models: state.stories,
                          index: item.id - 1,
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

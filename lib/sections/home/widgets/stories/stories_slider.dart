import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/sections/stories/cubit/stories_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoriesSlider extends StatefulWidget {
  const StoriesSlider({Key? key}) : super(key: key);

  @override
  State<StoriesSlider> createState() => _StoriesSliderState();
}

class _StoriesSliderState extends State<StoriesSlider> {
  final storiesCubit = StoriesCubit();

  @override
  void dispose() {
    super.dispose();
    storiesCubit.close();
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
              children: state.stories.map((item) {
                if (item != null) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Story(
                      model: item,
                    ),
                  );
                }
                return Container();
                // returnStories(item);
              }).toList(),
            ),
          );
        }
        if (state is StoriesFailed) {
          debugPrint(state.title);
        }
        return const Center(
          // child: CircularProgressIndicator.adaptive(),
          child: AnimatedLoader(),
        );
      },
    );
  }

  void deleteKeys(int id) async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('story[$id]')) {
      prefs.remove('story[$id]');
    }
  }
}

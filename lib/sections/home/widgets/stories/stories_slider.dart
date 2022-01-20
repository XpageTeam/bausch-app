import 'dart:async';

import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/sections/stories/cubit/stories_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoriesSlider extends StatefulWidget {
  const StoriesSlider({Key? key}) : super(key: key);

  @override
  State<StoriesSlider> createState() => _StoriesSliderState();
}

class _StoriesSliderState extends State<StoriesSlider> {
  late StoriesCubit storiesCubit;

  @override
  void initState() {
    storiesCubit = StoriesCubit(
      context: context,
    );

    storiesCubitGlobal = storiesCubit;
    super.initState();
  }

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
        if (state is StoriesSuccess ||
            (state is StoriesLoading && state.stories != null)) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.sidePadding,
            ),
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.stories!.map((item) {
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
          return const SizedBox();
        }

        return const Center(
          child: AnimatedLoader(),
        );
      },
    );
  }

  Future<void> deleteKeys(int id) async {
    final userWM = Provider.of<UserWM>(context);

    final prefs = await SharedPreferences.getInstance();

    await prefs
        .remove('user[${userWM.userData.value.data?.user.id}]story[$id]');
  }
}

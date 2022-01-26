import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class Story extends CoreMwwmWidget<StoryWM> {
  final StoryModel model;

  Story({
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            model.wm.context = context;
            return model.wm;
          },
        );

  @override
  WidgetState<CoreMwwmWidget<StoryWM>, StoryWM> createWidgetState() =>
      _StoryState();
}

class _StoryState extends WidgetState<Story, StoryWM> {
  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<bool>(
      streamedState: wm.isVisible,
      builder: (_, isVisible) {
        if (isVisible) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width -
                        StaticData.sidePadding * 2) /
                    3 -
                2.5,
            child: GestureDetector(
              onTap: () {
                wm.showStoryAction(widget.model);
              },
              child: AspectRatio(
                aspectRatio: 114 / 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ExtendedImage.network(
                          widget.model.content.first.preview,
                          fit: BoxFit.cover,
                          printError: false,
                          loadStateChanged: loadStateChangedFunction,
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
                              widget.model.content.first.title,
                              style: AppStyles.h2WhiteBold,
                            ),
                            Text(
                              widget.model.content.length.toString(),
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

        return const SizedBox();
      },
    );
  }
}

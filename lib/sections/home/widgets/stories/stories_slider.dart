import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/home/widgets/stories/stories_wm.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class StoriesSlider extends CoreMwwmWidget<StoriesWM> {
  final List<StoryModel> items;

  StoriesSlider({
    required this.items,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => StoriesWM(
            stories: items,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<StoriesWM>, StoriesWM> createWidgetState() =>
      _StoriesSliderState();
}

class _StoriesSliderState extends WidgetState<StoriesSlider, StoriesWM> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      clipBehavior: Clip.none,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Provider(
        create: (context) => wm,
        lazy: false,
        child: Row(
          // TODO(pavlov): тут нажимаются истории
          children: widget.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Story(
                model: item,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Provider(
//         create: (context) => wm,
//         child: Row(
//           children: widget.items.map((item) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 4),
//               child: Story(
//                 model: item,
//               ),
//             );
//           }).toList(),
//         ),
//       )

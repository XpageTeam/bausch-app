import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/stories/story_view/aimated_bar.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class BottomContent extends StatelessWidget {
  final StoryModel story;
  final AnimationController animController;
  final int contentIndex;

  const BottomContent({
    required this.story,
    required this.animController,
    required this.contentIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.0,
      left: 10.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              story.content.length,
              (index) => AnimatedBar(
                animController: animController,
                position: index,
                currentIndex: contentIndex,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (story.content[contentIndex].title != null &&
              story.content[contentIndex].title!.isNotEmpty)
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width > 330 ? 20 : 10,
              ),
              child: Text(
                story.content[contentIndex].title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width < 330 ? 21 : 41,
                  height: 42 / 41,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (story.content[contentIndex].description != null &&
              story.content[contentIndex].description!.isNotEmpty)
            Html(
              data: story.content[contentIndex].description,
              style: storyTextHtmlStyles,
              customRender: htmlCustomRender,
            ),
        ],
      ),
    );
  }
}

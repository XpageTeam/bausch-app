import 'package:bausch/sections/stories/story_items/story_item_image.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
              inline: true,
              storyItems: [
                StoryItem(
                  ImageStoryItemView(),
                  duration: Duration(seconds: 5),
                ),
                StoryItem(
                  ImageStoryItemView(),
                  duration: Duration(seconds: 5),
                ),
              ],
              controller: controller),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 22,
                right: 12,
              ),
              child: Align(
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        onPressed: () {
                          debugPrint('Выход из сторис');
                        },
                        icon: Icon(
                          Icons.close,
                          color: Color(0xFF2D2D2D),
                        )),
                  ),
                  alignment: Alignment.topRight),
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 24,
        height: 60,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Участвовать в акции',
                style: AppStyles.h3,
              ),
              SizedBox(width: 8),
              Icon(
                Icons.add,
                color: Color(0xFF2D2D2D),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/*//Кнопка выхода из сторис
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Align(
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    debugPrint('Выход из сторис');
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Color(0xFF2D2D2D),
                                  )),
                            ),
                            alignment: Alignment.topRight),
                      ) */

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
      body: StoryView(
          inline: true,
          storyItems: [
            StoryItem.pageProviderImage(
                const AssetImage('assets/pic1.png') as ImageProvider),
            StoryItem.pageProviderImage(
                const AssetImage('assets/pic2.png') as ImageProvider),
          ],
          controller: controller),
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
              children: [
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
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/*CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.close,
                      color: Color(0xFF2D2D2D),
                    )),
              ), */

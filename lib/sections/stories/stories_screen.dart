// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/stories/stories_bottom_button.dart';
import 'package:bausch/sections/stories/story_view/aimated_bar.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';

//тут ничего почти не менял,добавил методы _onLongPressStart , _onLongPressEnd
//откуда всё взял: https://github.com/MarcusNg/flutter_instagram_stories

class StoriesScreen extends StatefulWidget {
  final StoryModel storyModel;
  const StoriesScreen({
    required this.storyModel,
    //required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late VideoPlayerController _videoPlayerController;
  late int _currentIndex;
  late Widget img;

  //bool isContentLoaded = false;

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    _videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );

    final firstStory = widget.storyModel.content.first;

    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animController.stop();
          _animController.reset();

          setState(
            () {
              if (_currentIndex + 1 < widget.storyModel.content.length) {
                _currentIndex += 1;
                _loadStory(story: widget.storyModel.content[_currentIndex]);
              } else {
                // Out of bounds - loop story
                //_animController.stop();
                Navigator.of(context).pop();
                //_currentIndex = 0;
                //_loadStory(story: widget.stories[_currentIndex]);
              }
            },
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.storyModel.content[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) => _onTapUp(details, story),
        onLongPressStart: (details) => _onLongPressStart(details, story),
        onLongPressEnd: (details) => _onLongPressEnd(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.storyModel.content.length,
              itemBuilder: (context, i) {
                //final StoryModel story = widget.stories[i];
                switch (story.isVideo) {
                  case false:
                    return Image.network(
                      story.file ?? story.preview,
                      fit: BoxFit.cover,
                    );
                  case true:
                    if (_videoPlayerController.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController.value.size.width,
                          height: _videoPlayerController.value.size.height,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      );
                    }
                }
                return Image.network(
                  story.preview,
                  fit: BoxFit.cover,
                  //color: Colors.red.withAlpha(10),
                );
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: List.generate(
                      widget.storyModel.content.length,
                      (index) => AnimatedBar(
                        animController: _animController,
                        position: index,
                        currentIndex: _currentIndex,
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
                    height: 20,
                  ),
                  Text(
                    widget.storyModel.content[_currentIndex].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 41,
                      height: 42 / 41,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Html(
                    data: widget.storyModel.content[_currentIndex].description,
                    style: storyTextHtmlStyles,
                    customRender: htmlCustomRender,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StoriesBottommButton(
        link: story.link,
        buttonText: story.textBtn,
        productModel: story.productModel,
        textAfter: story.textAfter,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onTapUp(TapUpDetails details, StoryContentModel story) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(
        () {
          if (_currentIndex - 1 >= 0) {
            _currentIndex -= 1;
            _loadStory(story: widget.storyModel.content[_currentIndex]);
          }
        },
      );
    } else if (dx > screenWidth * 2 / 3) {
      setState(
        () {
          if (_currentIndex + 1 < widget.storyModel.content.length) {
            _currentIndex += 1;
            _loadStory(story: widget.storyModel.content[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: widget.storyModel.content[_currentIndex]);
          }
        },
      );
    }
  }

  void _onLongPressStart(
    LongPressStartDetails details,
    StoryContentModel story,
  ) {
    _animController.stop();
    if (story.isVideo) {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      }
    }
  }

  void _onLongPressEnd(LongPressEndDetails details, StoryContentModel story) {
    _animController.forward();
    if (story.isVideo) {
      _videoPlayerController.play();
    }
  }

  Future<void> _loadStory({
    required StoryContentModel story,
    bool animateToPage = true,
  }) async {
    _animController.stop();
    _animController.reset();

    switch (story.isVideo) {
      case false:
        img = Image.network(
          story.file ?? story.preview,
          fit: BoxFit.cover,
        );

        final stream = (img as Image).image.resolve(ImageConfiguration.empty);

        final completer = Completer<void>();

        stream.addListener(
          ImageStreamListener(
            (info, flag) => completer.complete(),
          ),
        );
        await completer.future;
        if (mounted) {
          _animController.duration = story.duration;
          _animController.forward();
        }

        break;
      case true:
        //_videoPlayerController = null;
        _videoPlayerController.dispose();
        _videoPlayerController = VideoPlayerController.network(story.file!)
          ..initialize().then(
            (_) {
              setState(() {});
              if (_videoPlayerController.value.isInitialized) {
                _animController.duration =
                    _videoPlayerController.value.duration;
                _videoPlayerController.play();
                _animController.forward();
              }
            },
          );
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

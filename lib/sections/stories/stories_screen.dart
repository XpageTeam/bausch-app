// ignore_for_file: cascade_invocations, avoid-returning-widgets

import 'dart:async';

import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/stories/bottom_content.dart';
import 'package:bausch/sections/stories/stories_bottom_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//тут ничего почти не менял,добавил методы _onLongPressStart , _onLongPressEnd
//откуда всё взял: https://github.com/MarcusNg/flutter_instagram_stories

class StoriesScreen extends StatefulWidget {
  final int storyModel;
  final List<StoryModel> stories;
  const StoriesScreen({
    required this.storyModel,
    required this.stories,
    //required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>
    with SingleTickerProviderStateMixin {
  //late StoriesWM storiesWM;

  late int index;

  late Widget img;
  int pageNumTemp = 0;
  int pageNum = 0;
  late PageController _pageController;
  late AnimationController _animController;
  late VideoPlayerController _videoPlayerController;
  late int _currentIndex;

  //bool isContentLoaded = false;

  int _currentIndexTemp = 0;

  @override
  void initState() {
    index =
        widget.stories.indexWhere((element) => element.id == widget.storyModel);

    _currentIndex = 0;
    _pageController = PageController(initialPage: index);
    _animController = AnimationController(vsync: this);
    _videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );

    final firstStory = widget.stories[index].content.first;

    _loadStory(storyContent: firstStory);

    _animController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animController.stop();
          _animController.reset();

          setState(
            () {
              if (_currentIndex + 1 < widget.stories[index].content.length) {
                _currentIndex += 1;
                _loadStory(
                  storyContent: widget.stories[index].content[_currentIndex],
                );
              } else {
                unawaited(
                  FirebaseAnalytics.instance.logEvent(
                    name: 'story_showed',
                    parameters: <String, dynamic>{
                      'id': widget.stories[index].id,
                      'title': widget.stories[index].content[0].title,
                    },
                  ),
                );
                _moveToNextStory();
              }
            },
          );
        }
      },
    );

    _pageController.addListener(
      () {
        pageNum = _pageController.page!.round();
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
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          debugPrint('start');

          final i = _pageController.page!.round();
          pageNumTemp = i;
          _currentIndexTemp = _currentIndex;
          _currentIndex = 0;
          final storyContent = widget.stories[i].content[_currentIndex];
          _onLongPressStart(storyContent);
        }

        if (notification is ScrollEndNotification) {
          debugPrint('end');
          final i = _pageController.page!.round();
          setState(
            () {
              index = i;
              if (index == pageNumTemp) {
                _currentIndex = _currentIndexTemp;
              } else {
                _currentIndex = 0;
              }

              _loadStory(
                storyContent: widget.stories[i].content[_currentIndex],
              );
            },
          );
        }
        return true;
      },
      child: PageView.builder(
        controller: _pageController,
        dragStartBehavior: DragStartBehavior.down,
        itemCount: widget.stories.length,
        itemBuilder: (context, i) {
          //* костыль, чтобы не появлялся серый экран, когда проскроллил не до конца
          final story = widget.stories[i];

          final storyContent = widget.stories[i].content[_currentIndex];

          return Scaffold(
            backgroundColor: Colors.black,
            body: GestureDetector(
              onTapUp: (details) => _onTapUp(details, storyContent),
              onLongPressStart: (details) => _onLongPressStart(storyContent),
              onLongPressEnd: (details) => _onLongPressEnd(storyContent),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _getBackground(storyContent),
                  BottomContent(
                    story: story,
                    animController: _animController,
                    contentIndex: _currentIndex,
                  ),
                ],
              ),
            ),
            floatingActionButton: StoriesBottommButton(
              link: storyContent.link,
              buttonText: storyContent.textBtn,
              productModel: storyContent.productModel,
              textAfter: storyContent.textAfter,
              textFooter: storyContent.textFooter,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  Widget _getBackground(StoryContentModel storyContent) {
    switch (storyContent.isVideo) {
      case false:
        return ExtendedImage.network(
          storyContent.file ?? storyContent.preview,
          fit: BoxFit.cover,
          printError: false,
          loadStateChanged: loadStateChangedFunction,
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
    return ExtendedImage.network(
      storyContent.preview,
      fit: BoxFit.cover,
      printError: false,
      loadStateChanged: loadStateChangedFunction,
      //color: Colors.red.withAlpha(10),
    );
  }

  void _onTapUp(TapUpDetails details, StoryContentModel storyContent) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(
        () {
          if (_currentIndex - 1 >= 0) {
            _currentIndex -= 1;
            _loadStory(
              storyContent: widget.stories[index].content[_currentIndex],
            );
          } else {
            _moveToPreviousStory();
          }
        },
      );
    } else if (dx > screenWidth * 2 / 3) {
      setState(
        () {
          if (_currentIndex + 1 < widget.stories[index].content.length) {
            _currentIndex += 1;
            _loadStory(
              storyContent: widget.stories[index].content[_currentIndex],
            );
          } else {
            // Out of bounds - loop storyContent
            // You can also Navigator.of(context).pop() here
            _moveToNextStory();
          }
        },
      );
    }
  }

  void _moveToPreviousStory() {
    if (index > 0) {
      //index -= 1;
      _pageController.animateToPage(
        index - 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      _currentIndex = 0;
      _loadStory(
        storyContent: widget.stories[index].content[_currentIndex],
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _moveToNextStory() {
    if (index < widget.stories.length - 1) {
      //index += 1;
      _pageController.animateToPage(
        index + 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    } else {
      Navigator.of(context).pop();
    }
    _currentIndex = 0;
    _loadStory(
      storyContent: widget.stories[index].content[_currentIndex],
    );
  }

  void _onLongPressStart(
    StoryContentModel storyContent,
  ) {
    _animController.stop();
    if (storyContent.isVideo) {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      }
    }
  }

  void _onLongPressEnd(StoryContentModel storyContent) {
    _animController.forward();
    if (storyContent.isVideo) {
      _videoPlayerController.play();
    }
  }

  Future<void> _loadStory({
    required StoryContentModel storyContent,
    //bool animateToPage = true,
  }) async {
    _animController.stop();
    _animController.reset();

    if (_videoPlayerController.value.isInitialized) {
      await _videoPlayerController.pause();
    }

    switch (storyContent.isVideo) {
      case false:
        img = ExtendedImage.network(
          storyContent.file ?? storyContent.preview,
          fit: BoxFit.cover,
          printError: false,
          loadStateChanged: loadStateChangedFunction,
        );

        final stream =
            (img as ExtendedImage).image.resolve(ImageConfiguration.empty);

        final completer = Completer<void>();

        stream.addListener(
          ImageStreamListener(
            (info, flag) => completer.complete(),
          ),
        );
        await completer.future;
        if (mounted) {
          _animController.duration = storyContent.duration;
          // ignore: unawaited_futures
          _animController.forward();
        }

        break;
      case true:
        //_videoPlayerController = null;
        // ignore: unawaited_futures
        _videoPlayerController.dispose();
        _videoPlayerController =
            VideoPlayerController.network(storyContent.file!)
              // ignore: unawaited_futures
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
    // if (animateToPage) {
    //   // ignore: unawaited_futures
    //   _pageController.animateToPage(
    //     _currentIndex,
    //     duration: const Duration(milliseconds: 1),
    //     curve: Curves.easeInOut,
    //   );
    // }
  }
}

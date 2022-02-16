// ignore_for_file: cascade_invocations, avoid-returning-widgets

import 'dart:async';

import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/models/stories/story_model.dart';
import 'package:bausch/sections/home/widgets/stories/stories_wm.dart';
import 'package:bausch/sections/stories/stories_bottom_button.dart';
import 'package:bausch/sections/stories/story_background.dart';
import 'package:bausch/sections/stories/story_view/aimated_bar.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
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
  late PageController _pageController;
  late AnimationController _animController;
  late VideoPlayerController _videoPlayerController;
  late int _currentIndex;

  //bool isContentLoaded = false;

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

    _loadStory(story: firstStory);

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
                  story: widget.stories[index].content[_currentIndex],
                );
              } else {
                _moveToNextStory();
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
    // final index =
    //     widget.stories.indexWhere((element) => element.id == widget.storyModel);

    return PageView.builder(
      controller: _pageController,
      dragStartBehavior: DragStartBehavior.down,
      //physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (i) {
        debugPrint('page $i');
        setState(() {
          index = i;
          _currentIndex = 0;
          _loadStory(story: widget.stories[i].content[_currentIndex]);
        });
      },
      itemCount: widget.stories.length,

      itemBuilder: (context, i) {
        //* костыль, чтобы не появлялся серый экран, когда проскроллил не до конца
        final story = widget.stories[i].content[
            _currentIndex < widget.stories[i].content.length - 1
                ? _currentIndex
                : 0];
        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTapUp: (details) => _onTapUp(details, story),
            onLongPressStart: (details) => _onLongPressStart(story),
            onLongPressEnd: (details) => _onLongPressEnd(story),
            // onHorizontalDragStart: (details) => _onLongPressStart(story),
            // onHorizontalDragEnd: (details) => _onLongPressEnd(story),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _getBackground(story),
                _getBottomContent(),
              ],
            ),
          ),
          floatingActionButton: StoriesBottommButton(
            link: story.link,
            buttonText: story.textBtn,
            productModel: story.productModel,
            textAfter: story.textAfter,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );

    // return Scaffold(
    //   backgroundColor: Colors.black,
    //   body: GestureDetector(
    //     onTapUp: (details) => _onTapUp(details, story),
    //     onLongPressStart: (details) => _onLongPressStart(details, story),
    //     onLongPressEnd: (details) => _onLongPressEnd(details, story),
    //     child: PageView.builder(
    //       controller: _pageController,
    //       //physics: const NeverScrollableScrollPhysics(),
    //       onPageChanged: (i) {
    //         debugPrint('page $i');
    //       },
    //       itemCount: widget.stories.length,
    //       itemBuilder: (context, i) {
    //         //final StoryModel story = widget.stories[i];
    //         return Stack(
    //           fit: StackFit.expand,
    //           children: [
    //             _getBackground(story),
    //             _getBottomContent(),
    //           ],
    //         );
    //       },
    //     ),
    //   ),
    //   floatingActionButton: StoriesBottommButton(
    //     link: story.link,
    //     buttonText: story.textBtn,
    //     productModel: story.productModel,
    //     textAfter: story.textAfter,
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // );
  }

  Widget _getBackground(StoryContentModel story) {
    switch (story.isVideo) {
      case false:
        return ExtendedImage.network(
          story.file ?? story.preview,
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
      story.preview,
      fit: BoxFit.cover,
      printError: false,
      loadStateChanged: loadStateChangedFunction,
      //color: Colors.red.withAlpha(10),
    );
  }

  Widget _getBottomContent() {
    return Positioned(
      top: 40.0,
      left: 10.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: List.generate(
              widget.stories[index].content.length,
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
            widget.stories[index].content[_currentIndex].title,
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
            data: widget.stories[index].content[_currentIndex].description,
            style: storyTextHtmlStyles,
            customRender: htmlCustomRender,
          ),
        ],
      ),
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
            _loadStory(
              story: widget.stories[index].content[_currentIndex],
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
              story: widget.stories[index].content[_currentIndex],
            );
          } else {
            // Out of bounds - loop story
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
        story: widget.stories[index].content[_currentIndex],
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
      story: widget.stories[index].content[_currentIndex],
    );
  }

  void _onLongPressStart(
    //LongPressStartDetails details,
    StoryContentModel story,
  ) {
    _animController.stop();
    if (story.isVideo) {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      }
    }
  }

  void _onLongPressEnd(StoryContentModel story) {
    _animController.forward();
    if (story.isVideo) {
      _videoPlayerController.play();
    }
  }

  Future<void> _loadStory({
    required StoryContentModel story,
    //bool animateToPage = true,
  }) async {
    _animController.stop();
    _animController.reset();

    if (_videoPlayerController.value.isInitialized) {
      await _videoPlayerController.pause();
    }

    switch (story.isVideo) {
      case false:
        img = ExtendedImage.network(
          story.file ?? story.preview,
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
          _animController.duration = story.duration;
          // ignore: unawaited_futures
          _animController.forward();
        }

        break;
      case true:
        //_videoPlayerController = null;
        // ignore: unawaited_futures
        _videoPlayerController.dispose();
        _videoPlayerController = VideoPlayerController.network(story.file!)
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

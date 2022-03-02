// ignore_for_file: avoid_annotating_with_dynamic, unused_import, avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/mappable_object.dart';
import 'package:bausch/models/stories/story_content_model.dart';
import 'package:bausch/sections/home/widgets/stories/stories_wm.dart';
import 'package:bausch/sections/home/widgets/stories/story.dart';
import 'package:bausch/sections/stories/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class StoryWM extends WidgetModel {
  final int id;
  final StreamedState<int> viewsConunt;
  final isVisible = StreamedState<bool>(true);

  // final int storyIndex;

  final checkVisibleAction = VoidAction();
  final incViewCountAction = VoidAction();
  final showStoryAction = StreamedAction<StoryModel>();

  final _prefs = SharedPreferences.getInstance();

  BuildContext? context;
  UserWM? userWM;

  StoriesWM? storiesWM;

  StoryWM({
    required this.id,
    required int views,
    // required this.storyIndex,
    this.context,
  })  : viewsConunt = StreamedState(views),
        super(const WidgetModelDependencies());

  @override
  void onBind() {
    if (context != null) {
      userWM = Provider.of<UserWM>(context!, listen: false);
    }

    checkVisibleAction.bind((_) {
      _chekVisible();
    });

    incViewCountAction.bind((_) {
      _incViewCount().then((_) {
        _chekVisible();
      });
    });

    showStoryAction.bind(_showStory);

    checkVisibleAction();

    super.onBind();
  }

  Future<void> _showStory(StoryModel? model) async {
    if (context != null && model != null) {
      storiesWM = Provider.of<StoriesWM>(context!, listen: false);

      await Navigator.push<dynamic>(
        context!,
        PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) {
            return StoriesScreen(
              storyModel: id,
              stories: storiesWM!.stories,
            );
          },
          barrierColor: Colors.black.withOpacity(0.8),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            );
            return SlideTransition(
              position: Tween(
                begin: const Offset(0.0, 0.6),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );

      await incViewCountAction();
    }
  }

  Future<void> _chekVisible() async {
    final pref = await _prefs;

    final userID = userWM?.userData.value.data?.user.id;

    if (pref.containsKey('user[$userID]story[$id]')) {
      if ((pref.getInt('user[$userID]story[$id]') ?? 0) >= viewsConunt.value) {
        await isVisible.accept(false);
      } else {
        await isVisible.accept(true);
      }
    } else {
      await isVisible.accept(true);
    }
  }

  Future<void> _incViewCount() async {
    final pref = await _prefs;

    final userID = userWM?.userData.value.data?.user.id;

    final curViesCount = pref.getInt('user[$userID]story[$id]') ?? 0;

    await pref.setInt('user[$userID]story[$id]', curViesCount + 1);
  }
}

enum MediaType {
  image,
  video,
}

class StoryModel implements MappableInterface<StoryModel> {
  //* Идентификатр истории
  final int id;

  //* Название и ссылка на картинку
  final List<StoryContentModel> content;

  final StoryWM wm;

  // final int storyIndex;

  StoryModel({
    required this.id,
    required this.content,
    // required this.storyIndex,
    required int views,
  }) : wm = StoryWM(
          id: id,
          views: views,
          // storyIndex: storyIndex,
        );

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['id'] is! int) {
      throw ResponseParseException('Не передан идентификатор истории');
    }

    try {
      return StoryModel(
        content: (map['content'] as List<dynamic>)
            .map((dynamic story) =>
                StoryContentModel.fromMap(story as Map<String, dynamic>))
            .toList(),
        //media: MediaType.image,
        id: map['id'] as int,
        views: map['views'] as int,
        //duration: const Duration(seconds: 5),
      );
    } catch (e) {
      throw ResponseParseException('StoryModel: $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
    };
  }
}

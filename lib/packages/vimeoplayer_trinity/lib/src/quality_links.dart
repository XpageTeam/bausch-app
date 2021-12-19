// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//throw UnimplementedError();

class QualityLinks {
  String? videoId;

  QualityLinks(this.videoId);

  Future<SplayTreeMap<dynamic, dynamic>?> getQualitiesSync() {
    return getQualitiesAsync();
  }

  Future<SplayTreeMap?> getQualitiesAsync() async {
    try {
      final vimeoLink =
          Uri.tryParse('https://player.vimeo.com/video/${videoId!}/config');
      final response = await http.get(vimeoLink!);
      final jsonData =
          (((jsonDecode(response.body) as Map<String, dynamic>)['request']
                  as Map<String, dynamic>)['files']
              as Map<String, dynamic>)['progressive'] as List<dynamic>;
      final videoList = SplayTreeMap<String, String>.fromIterable(
        jsonData,
        key: (dynamic item) {
          item as Map<String, dynamic>;

          return "${item['quality']} ${item['fps']}";
        },
        value: (dynamic item) {
          item as Map<String, dynamic>;

          return item['url'] as String;
        },
      );
      return videoList;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      debugPrint('=====> REQUEST ERROR: $error');
      return null;
    }
  }
}

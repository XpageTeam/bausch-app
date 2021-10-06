enum MediaType {
  image,
  video,
}

class StoryModel {
  final String url;
  final MediaType media;
  final Duration duration;
  final int index;
  final String? buttonTitle;
  final String? mainText;
  final String? secondText;

  const StoryModel({
    required this.url,
    required this.media,
    required this.duration,
    required this.index,
    this.buttonTitle,
    this.mainText,
    this.secondText,
  });
}

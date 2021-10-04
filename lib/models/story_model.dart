enum MediaType {
  image,
  video,
}

class Story {
  final String url;
  final MediaType media;
  final Duration duration;
  final String? buttonTitle;
  final String? mainText;
  final String? secondText;

  const Story({
    required this.url,
    required this.media,
    required this.duration,
    this.buttonTitle,
    this.mainText,
    this.secondText,
  });
}

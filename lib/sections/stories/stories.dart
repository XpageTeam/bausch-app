import 'package:bausch/models/story_model.dart';

final List<Story> stories = [
  const Story(
      url: 'assets/pic1.png',
      media: MediaType.image,
      duration: Duration(seconds: 5),
      buttonTitle: 'hbuvjh',
      mainText: 'Миллион впечатлений с ReNu',
      secondText:
          'Зарегистрируйте чек и выиграйте путешествия мечты от ReNu. Всем участникам гарантированные призы!'),
  const Story(
      url: 'assets/pic2.png',
      media: MediaType.image,
      duration: Duration(seconds: 5),
      buttonTitle: 'my',
      mainText: 'Прояви к глазам уважение',
      secondText:
          'Выбирай Biotrue ONEday и выигрывай один из главных призов: sddfsdfsff'),
  const Story(
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    media: MediaType.video,
    duration: Duration(seconds: 3),
    mainText: 'Ахахаха пчела',
    buttonTitle: 'name',
  ),
  const Story(
    url: 'assets/pic2.png',
    media: MediaType.image,
    duration: Duration(seconds: 5),
    buttonTitle: 'is',
  ),
];

// import 'package:flutter/material.dart';

// class UnderlinedText extends StatelessWidget {
//   final double space;
//   final String text;
//   final TextStyle textStyle;
//   final Color lineColor;
//   final double lineWidth;
//   const UnderlinedText({
//     required this.space,
//     required this.text,
//     required this.textStyle,
//     required this.lineWidth,
//     required this.lineColor,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return UnderlinedTextRaw(
//           maxWidth: constraints.maxWidth,
//           verticalSpacing: space,
//           text: text,
//           textStyle: textStyle,
//           paintLine: Paint()
//             ..style = PaintingStyle.stroke
//             ..color = lineColor
//             ..strokeWidth = lineWidth,
//         );
//       },
//     );
//   }
// }

// class UnderlinedTextRaw extends StatelessWidget {
//   final String text;
//   final double verticalSpacing;
//   final TextStyle textStyle;
//   final Paint paintLine;
//   final double maxWidth;

//   const UnderlinedTextRaw({
//     required this.text,
//     required this.textStyle,
//     required this.paintLine,
//     required this.verticalSpacing,
//     required this.maxWidth,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final sizeWholeLine = getSizeWholeLine();
//     final height = calcHeight();
//     final lines = makeLines();

//     final customPaint = CustomPaint(
//       child: SizedBox(
//         height: height,
//         width: maxWidth,
//       ),
//       foregroundPainter: _Painter(
//         maxWidth: maxWidth,
//         text: text,
//         verticalSpacing: verticalSpacing,
//         textStyle: textStyle,
//         paintLine: paintLine,
//         lineHeight: sizeWholeLine.height,
//         lines: lines,
//       ),
//     );

//     return customPaint;
//   }

//   // Пока что просто скопировал
//   List<String> makeLines() {
//     final tp = TextPainter(
//       textDirection: TextDirection.ltr,
//     );

//     final list = text.split(' ');
//     var width = 0.0;
//     var lineText = '';
//     final arr = <String>[];

//     for (var i = 0; i < list.length; i++) {
//       final value = tp
//         ..text = TextSpan(
//           text: '${list[i]} ',
//           style: textStyle,
//         )
//         ..layout(
//           maxWidth: double.maxFinite,
//         );

//       if (width + value.width > maxWidth) {
//         debugPrint('width: $width \t text: $lineText');
//         width = 0.0;

//         arr.add(
//           lineText.substring(0, lineText.length - 1),
//         );
//         lineText = '';
//       }
//       width += value.width;
//       lineText += '${list[i]} ';
//     }

//     arr.add(
//       lineText.substring(0, lineText.length - 1),
//     );

//     return arr;
//   }

//   double calcHeight() {
//     final tp = TextPainter(
//       textDirection: TextDirection.ltr,
//     );

//     final list = text.split(' ');
//     var width = 0.0;
//     var lineText = '';
//     final arr = <String>[];

//     for (var i = 0; i < list.length; i++) {
//       final value = tp
//         ..text = TextSpan(
//           text: '${list[i]} ',
//           style: textStyle,
//         )
//         ..layout(
//           maxWidth: double.maxFinite,
//         );

//       if (width + value.width > maxWidth) {
//         width = 0.0;

//         arr.add(lineText);
//         lineText = '';
//       }
//       width += value.width;
//       lineText += '${list[i]} ';
//     }

//     arr.add(lineText);

//     return tp.height * arr.length;
//   }

//   double calcFullHeight(Size size) {
//     final lines = (size.width / maxWidth).ceil();
//     return size.height * lines;
//   }

//   Size getSizeWholeLine() {
//     final value = TextPainter(
//       textDirection: TextDirection.ltr,
//     )
//       ..text = TextSpan(
//         text: text,
//         style: textStyle,
//       )
//       ..layout(
//         maxWidth: double.maxFinite,
//       );

//     return value.size;
//   }
// }

// class _Painter extends CustomPainter {
//   final String text;
//   final TextStyle textStyle;
//   final double verticalSpacing;
//   final Paint paintLine;
//   final double maxWidth;
//   final double lineHeight;
//   final List<String> lines;
//   final _textPainter = TextPainter(
//     textDirection: TextDirection.ltr,
//   );

//   _Painter({
//     required this.text,
//     required this.verticalSpacing,
//     required this.paintLine,
//     required this.textStyle,
//     required this.maxWidth,
//     required this.lineHeight,
//     required this.lines,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.translate(
//       0,
//       lineHeight / 1.2,
//     ); //пока что неизвестное число "1.2"

//     // var sumWidth = 0.0;

//     // _textPainter
//     //   ..text = TextSpan(
//     //     text: text,
//     //     style: textStyle,
//     //   )
//     //   ..layout(
//     //     maxWidth: maxWidth,
//     //   )
//     //   ..paint(
//     //     canvas,
//     //     Offset.zero,
//     //   );
//     // отдельно добавлять подчеркивание

//     // canvas.translate(
//     //   0,
//     //   _textPainter.height,
//     // );

//     for (var i = 0; i < lines.length; i++) {
//       _drawLine(canvas, lines[i], maxWidth);
//     }
//     // for (var i = 0; i < text.length; i++) {
//     //   if (sumWidth >= maxWidth) {
//     //     canvas.translate(-sumWidth, lineHeight);
//     //     sumWidth = 0.0;
//     //   }
//     //   sumWidth += _drawLetter(canvas, text[i], maxWidth);
//     // }
//   }

//   double _drawLine(
//     Canvas canvas,
//     String line,
//     double maxWidth,
//   ) {
//     _textPainter
//       ..text = TextSpan(
//         text: line,
//         style: textStyle,
//       )
//       ..layout(
//         maxWidth: double.maxFinite,
//       );

//     canvas.drawLine(
//       Offset(
//         0,
//         verticalSpacing - 5,
//       ), // Пока что неизвестное число "5"
//       Offset(
//         _textPainter.width,
//         verticalSpacing - 5,
//       ), // Пока что неизвестные числа "5"
//       paintLine,
//     );

//     _textPainter.paint(
//       canvas,
//       Offset(
//         0,
//         -_textPainter.height,
//       ),
//     );
//     canvas.translate(
//       0,
//       _textPainter.height,
//     );

//     return 1;
//   }

//   // double _drawLetter(
//   //   Canvas canvas,
//   //   String letter,
//   //   double maxWidth,
//   // ) {
//   //   _textPainter
//   //     ..text = TextSpan(
//   //       text: letter,
//   //       style: textStyle,
//   //     )
//   //     ..layout(
//   //       maxWidth: double.maxFinite,
//   //     );

//   //   final letterWidth =
//   //       _textPainter.width - 0.5; // Пока что неизвестное число "0.5"
//   //   debugPrint('letter height: ${_textPainter.height}');
//   //   // _textPainter.
//   //   canvas.drawLine(
//   //     Offset(
//   //       0,
//   //       verticalSpacing - 5,
//   //     ), // Пока что неизвестное число "5"
//   //     Offset(
//   //       letterWidth,
//   //       verticalSpacing - 5,
//   //     ), // Пока что неизвестные числа "5"
//   //     paintLine,
//   //   );

//   //   _textPainter.paint(
//   //     canvas,
//   //     Offset(
//   //       0,
//   //       -_textPainter.height,
//   //     ),
//   //   );

//   //   canvas.translate(letterWidth, 0);

//   //   return letterWidth;
//   // }

//   // double _drawLetter(Canvas canvas, String letter, double prevAngle) {
//   //   _textPainter
//   //     ..text = TextSpan(text: letter, style: textStyle)
//   //     ..layout(
//   //       maxWidth: double.maxFinite,
//   //     );

//   //   final d = _textPainter.width;
//   //   final alpha = 2 * math.asin(d / (radius * 2));

//   //   final newAngle = _calculateRotationAngle(prevAngle, alpha);
//   //   canvas.rotate(newAngle);

//   //   _textPainter.paint(canvas, Offset(0, -_textPainter.height));
//   //   canvas.translate(d, 0);

//   //   return alpha;
//   // }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

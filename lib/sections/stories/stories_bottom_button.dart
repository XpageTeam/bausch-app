import 'package:bausch/help/utils.dart';
import 'package:bausch/models/stories/product_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:bausch/theme/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class StoriesBottommButton extends StatelessWidget {
  final String? link;
  final String? buttonText;
  final ProductModel? productModel;
  final String? textAfter;
  final String? textFooter;

  const StoriesBottommButton({
    this.link,
    this.buttonText,
    this.productModel,
    this.textAfter,
    this.textFooter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('$buttonText $link');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (productModel != null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: WhiteContainerWithRoundedCorners(
                child: Padding(
                  padding: const EdgeInsets.all(
                    StaticData.sidePadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            productModel!.title,
                            style: AppStyles.p1,
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 100,
                      // ),
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 90,
                            maxHeight: MediaQuery.of(context).size.width < 330
                                ? 60
                                : 90,
                          ),
                          child: AspectRatio(
                            aspectRatio: 100 / 100,
                            child: ExtendedImage.network(
                              productModel!.picture,
                              printError: false,
                              loadStateChanged: loadStateChangedFunction,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          //* Если пришли ссылка для кнопки и текст
          if (link != null &&
              buttonText != null &&
              link!.isNotEmpty &&
              buttonText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                onPressed: () async =>
                    Utils.launchUrl(rawUrl: link!, isPhone: false),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText!,
                      style: AppStyles.h2,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      'assets/icons/link.png',
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          if (textAfter != null && textAfter!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Html(
                data: textAfter,
                style: storyTextAfterHtmlStyles,
                customRender: htmlCustomRender,
              ),
            ),
          if (textFooter != null && textFooter!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 6,
              ),
              child: Text(
                textFooter!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 16 / 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

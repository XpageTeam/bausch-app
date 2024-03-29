import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/home/widgets/offer_widget_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OfferWidget extends CoreMwwmWidget<OfferWidgetWM> {
  final Offer offer;

  final VoidCallback? onClose;
  final VoidCallback? onPressed;

  OfferWidget({
    required this.offer,
    this.onClose,
    this.onPressed,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => OfferWidgetWM(),
        );

  @override
  WidgetState<CoreMwwmWidget<OfferWidgetWM>, OfferWidgetWM>
      createWidgetState() => _OfferWidgetState();
}

class _OfferWidgetState extends WidgetState<OfferWidget, OfferWidgetWM> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // ignore: use_decorated_box
          Container(
            decoration: BoxDecoration(
              color: AppTheme.sulu,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: StaticData.sidePadding,
                left: StaticData.sidePadding,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 70 - StaticData.sidePadding,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        //* разбиваю текст на подстроки
                        final splittedText = HelpFunctions.getSplittedText(
                          constraints.maxWidth,
                          AppStyles.h1,
                          widget.offer.title,
                        );
                        wm.remainingStrings.clear();

                        if (splittedText.length > 2 &&
                            wm.remainingStrings.isEmpty) {
                          for (var i = 2; i < splittedText.length; i++) {
                            wm.remainingStrings.add(splittedText[i]);
                          }

                          wm.remainingString.accept(
                            wm.remainingStrings.join(),
                          );
                        }
                        return Text(
                          widget.offer.title,
                          style: AppStyles.h1,
                          maxLines: 2,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamedStateBuilder<String>(
                        streamedState: wm.remainingString,
                        builder: (_, remaining) {
                          return (widget.offer.description != null ||
                                  remaining.isNotEmpty)
                              ? Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 45.0),
                                    child: Text(
                                      remaining.isNotEmpty
                                          ? '$remaining\n${widget.offer.description ?? ''}'
                                          : widget.offer.description ?? '',
                                      style: AppStyles.p1,
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/banner-icon.png',
                            height: 70,
                          ),
                          const Positioned(
                            child: Icon(
                              Icons.arrow_forward_sharp,
                            ),
                            right: 13,
                          ),
                        ],
                      ),
                      // InkWell(
                      //   onTap: widget.onPressed,
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       Image.asset(
                      //         'assets/banner-icon.png',
                      //         height: 70,
                      //       ),
                      //       const Positioned(
                      //         child: Icon(
                      //           Icons.arrow_forward_sharp,
                      //         ),
                      //         right: 13,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (widget.offer.isClosable)
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
              splashRadius: 5,
            ),
        ],
      ),
    );
  }
}

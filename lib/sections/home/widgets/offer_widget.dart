import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OfferWidget extends StatefulWidget {
  final Offer offer;

  final VoidCallback? onClose;
  final VoidCallback? onPressed;

  const OfferWidget({
    required this.offer,
    this.onClose,
    this.onPressed,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.sulu,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: StaticData.sidePadding,
                left: StaticData.sidePadding,
                bottom: 30,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Text(
                      widget.offer.title,
                      style: AppStyles.h1,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.offer.description != null)
                        Flexible(
                          child: Text(
                            widget.offer.description!,
                            style: AppStyles.p1,
                          ),
                        ),
                      if (widget.offer.description == null) const SizedBox(),
                      InkWell(
                        onTap: widget.onPressed,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/banner-icon.png',
                              height: 60,
                            ),
                            const Positioned(
                              child: Icon(Icons.arrow_forward_sharp),
                              right: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
    );
  }
}

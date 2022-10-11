//ignore_for_file: avoid-unnecessary-setstate
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SelectShopSection extends StatefulWidget {
  final List<Optic> discountOptics;
  final DiscountType discountType;

  final void Function(Optic discountOptic) onChanged;

  final Optic? selectedOptic;

  const SelectShopSection({
    required this.selectedOptic,
    required this.discountOptics,
    required this.discountType,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectShopSection> createState() => _SelectShopSectionState();
}

class _SelectShopSectionState extends State<SelectShopSection> {
  int _selectedIndex = -1;

  @override
  void didUpdateWidget(covariant SelectShopSection oldWidget) {
    if (widget.selectedOptic == null) {
      setState(() => _selectedIndex = -1);
    }

    if (widget.selectedOptic != null) {
      final optics = widget.discountOptics;
      for (var i = 0; i < optics.length; i++) {
        if (optics[i].id == widget.selectedOptic!.id) {
          _selectedIndex = i;
          break;
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.discountOptics.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _SelectShopContainer(
            index: i,
            selectedIndex: _selectedIndex,
            optic: widget.discountOptics[i],
            onPressed: () {
              setState(() {
                _selectedIndex = i;
              });
              widget.onChanged(widget.discountOptics[i]);
            },
          ),
          // child: SizedBox(
          //   height: 74,
          //   child: TextButton(
          //     onPressed: () {
          //       setState(() {
          //         _selectedIndex = i;
          //       });
          //       widget.onChanged(widget.discountOptics[i]);
          //     },
          //     style: TextButton.styleFrom(
          //       backgroundColor: Colors.white,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       splashFactory: NoSplash.splashFactory,
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 12),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //             flex: 3,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 20.0),
          //                   child: AutoSizeText(
          //                     widget.discountOptics[i].title,
          //                     style: AppStyles.h2,
          //                     maxLines: 2,
          //                   ),
          //                 ),
          //                 if (widget.discountOptics[i].link!.isNotEmpty &&
          //                     widget.discountType == DiscountType.onlineShop)
          //                   Flexible(
          //                     child: GestureDetector(
          //                       onTap: () => Utils.tryLaunchUrl(
          //                         rawUrl: widget.discountOptics[i].link!,
          //                         onError: (ex) {
          //                           showDefaultNotification(
          //                             title: ex.title,
          //                             // subtitle: ex.subtitle,
          //                           );
          //                         },
          //                       ),
          //                       child: Text(
          //                         widget.discountOptics[i].link!
          //                             .replaceFirst('https://', ''),
          //                         style: AppStyles.p1Underlined,
          //                       ),
          //                     ),
          //                   ),
          //               ],
          //             ),
          //           ),
          //           Expanded(
          //             child: widget.discountOptics[i].logo != null
          //                 ? Padding(
          //                     padding: const EdgeInsets.only(left: 12.0),
          //                     child: ExtendedImage.network(
          //                       widget.discountOptics[i].logo!,
          //                       printError: false,
          //                       width: MediaQuery.of(context).size.width / 5,
          //                       loadStateChanged: loadStateChangedFunction,
          //                     ),
          //                   )
          //                 : const SizedBox(),
          //           ),
          //           const SizedBox(
          //             width: 20,
          //           ),
          //           CustomRadio(
          //             value: i,
          //             groupValue: _selectedIndex,
          //             onChanged: (v) {
          //               setState(() {
          //                 _selectedIndex = i;
          //               });
          //               widget.onChanged(widget.discountOptics[i]);
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

class _SelectShopContainer extends StatelessWidget {
  final Optic optic;
  final VoidCallback onPressed;
  final int index;
  final int selectedIndex;

  const _SelectShopContainer({
    required this.optic,
    required this.onPressed,
    required this.index,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      onTap: onPressed,
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.sidePadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    optic.title,
                    style: AppStyles.h2Bold,
                  ),
                  if (optic.link != null && optic.link!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: GestureDetector(
                        onTap: () => Utils.tryLaunchUrl(
                          rawUrl: optic.link!,
                          onError: (ex) {
                            showDefaultNotification(
                              title: ex.title,
                              // subtitle: ex.subtitle,
                            );
                          },
                        ),
                        child: const Text(
                          'Ссылка на сайт',
                          style: AppStyles.p1Underlined,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (optic.logo != null)
            Expanded(
              flex: 7,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                  ),
                  child: SizedBox(
                    width: 70,
                    child: ExtendedImage.network(
                      optic.logo!,
                      printError: false,
                      loadStateChanged: loadStateChangedFunction,
                    ),
                  ),
                ),
              ),
            ),
          CustomCheckbox(
            value: index == selectedIndex,
            marginNeeded: false,
            borderRadius: 12,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}

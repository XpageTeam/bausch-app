import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class SelectShopSection extends StatefulWidget {
  final List<DiscountOptic> discountOptics;
  const SelectShopSection({
    required this.discountOptics,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectShopSection> createState() => _SelectShopSectionState();
}

class _SelectShopSectionState extends State<SelectShopSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.discountOptics.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: SizedBox(
            height: 74,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = i;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              widget.discountOptics[i].title,
                              style: AppStyles.h2,
                            ),
                          ),
                          if (widget.discountOptics[i].link.isNotEmpty)
                            Text(
                              widget.discountOptics[i].link,
                              style: AppStyles.p1Underlined,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: widget.discountOptics[i].logo != null
                          ? Image.network(
                              widget.discountOptics[i].logo!,
                              width: MediaQuery.of(context).size.width / 5,
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomRadio(
                      value: i,
                      groupValue: _selectedIndex,
                      onChanged: (v) {
                        setState(() {
                          _selectedIndex = i;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (context, i) => Padding(
    //       padding: const EdgeInsets.only(bottom: 4),
    //       child: SizedBox(
    //         height: 74,
    //         child: TextButton(
    //           onPressed: () {
    //             setState(() {
    //               _selectedIndex = i;
    //             });
    //           },
    //           style: TextButton.styleFrom(
    //             backgroundColor: Colors.white,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(5),
    //             ),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 12),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               //crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       widget.discountOptics[i].title,
    //                       style: AppStyles.h3,
    //                     ),
    //                     if (widget.discountOptics[i].link.isNotEmpty)
    //                       Text(
    //                         widget.discountOptics[i].link,
    //                         style: AppStyles.p1Underlined,
    //                       ),
    //                   ],
    //                 ),

    //                 const SizedBox(
    //                   width: 20,
    //                 ),
    //                 if (widget.discountOptics[i].logo != null)
    //                   Image.asset(
    //                     widget.discountOptics[i].logo!,
    //                     width: MediaQuery.of(context).size.width / 5,
    //                   ),
    //                 CustomRadio(
    //                   value: i,
    //                   groupValue: _selectedIndex,
    //                   onChanged: (v) {
    //                     setState(() {
    //                       _selectedIndex = i;
    //                     });
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     childCount: widget.discountOptics.length,
    //   ),
    // );
  }
}

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class SelectShopSection extends StatefulWidget {
  final List<DiscountOptic> discountOptics;
  final DiscountType discountType;

  final void Function(DiscountOptic discountOptic) onChanged;

  const SelectShopSection({
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
                widget.onChanged(widget.discountOptics[i]);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                splashFactory: NoSplash.splashFactory,
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
                          if (widget.discountOptics[i].link.isNotEmpty &&
                              widget.discountType ==
                                  DiscountType.onlineShop)
                            GestureDetector(
                              onTap: () {
                                // TODO(Nikolay): Переход на сайт.
                              },
                              child: AutoSizeText(
                                widget.discountOptics[i].link
                                    .replaceFirst('https://', ''),
                                style: AppStyles.p1Underlined,
                                maxLines: 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: widget.discountOptics[i].logo != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Image.network(
                                widget.discountOptics[i].logo!,
                                width: MediaQuery.of(context).size.width / 5,
                              ),
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
                        widget.onChanged(widget.discountOptics[i]);
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
  }
}

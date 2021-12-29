import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
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
                          if (widget.discountOptics[i].link!.isNotEmpty &&
                              widget.discountType == DiscountType.onlineShop)
                            GestureDetector(
                              onTap: () => Utils.tryLaunchUrl(
                                rawUrl: widget.discountOptics[i].link!
                                    .replaceFirst('https://', ''),
                                isPhone: false,
                              ),
                              child: AutoSizeText(
                                widget.discountOptics[i].link!
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

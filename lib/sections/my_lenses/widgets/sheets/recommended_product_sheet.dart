import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/simple_webview_widget.dart';
import 'package:flutter/material.dart';

class RecommendedProductSheet extends StatefulWidget {
  final RecommendedProductModel product;
  final ScrollController controller;
  const RecommendedProductSheet({
    required this.controller,
    required this.product,
    super.key,
  });

  @override
  State<RecommendedProductSheet> createState() =>
      _RecommendedProductSheetState();
}

class _RecommendedProductSheetState extends State<RecommendedProductSheet> {
  Color buttonColor = AppTheme.mystic;
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      onScrolled: (offset) {
        if (offset > 60) {
          setState(() {
            buttonColor = AppTheme.turquoiseBlue;
          });
        } else {
          setState(() {
            buttonColor = AppTheme.mystic;
          });
        }
      },
      controller: widget.controller,
      resizeToAvoidBottomInset: false,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: const SizedBox(),
        iconColor: buttonColor,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(StaticData.sidePadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              WhiteContainerWithRoundedCorners(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60, bottom: 30),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Center(
                          child: Image.network(
                            widget.product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.sidePadding,
                      ),
                      child: Text(
                        widget.product.name,
                        style: AppStyles.h1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              WhiteContainerWithRoundedCorners(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 40,
                    left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                  ),
                  child: Text(
                    widget.product.description,
                    style: AppStyles.p1,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              BlueButton(
                onPressed: () => openSimpleWebView(
                  context,
                  url: widget.product.link,
                ),
                children: [
                  const Text(
                    'Где купить',
                    style: AppStyles.h2,
                  ),
                  const SizedBox(width: 9),
                  Image.asset(
                    'assets/icons/link.png',
                    height: 15,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Center(
                child: Text(
                  'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                  style: TextStyle(
                    fontSize: 14,
                    height: 16 / 14,
                    fontWeight: FontWeight.normal,
                    color: AppTheme.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

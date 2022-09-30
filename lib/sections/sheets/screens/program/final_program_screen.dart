import 'package:bausch/help/utils.dart';
import 'package:bausch/main.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/program/widget_model/program_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/bottom_button.dart';
import 'package:flutter/material.dart';

class FinalProgramScreen extends StatelessWidget {
  final ScrollController controller;
  final Optic optic;
  final ProgramSaverResponse response;

  FinalProgramScreen({
    required this.controller,
    required this.optic,
    required this.response,
    Key? key,
  }) : super(key: key){
    AppsflyerSingleton.sdk.logEvent('programmCertificateCreated', null);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 40),
                  child: Text(
                    'Это ваш сертификат на бесплатную диагностику зрения и первую пару контактных линз',
                    style: AppStyles.h1,
                  ),
                ),
                ContainerWithPromocode(
                  promocode: response.promocode,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 40,
                  ),
                  child: Text(
                    response.subtitle,
                    style: AppStyles.p1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Запишитесь в оптику заранее',
                    style: AppStyles.h1,
                  ),
                ),
                _OpticInfoWidget(
                  optic: optic,
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: const BottomButtonWithRoundedCorners(),
    );
  }
}

class _OpticInfoWidget extends StatelessWidget {
  final Optic optic;
  const _OpticInfoWidget({
    required this.optic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              optic.title,
              style: AppStyles.h2,
            ),
          ),
        ),
        Flexible(
          child: Text(
            optic.shops.first.address,
            style: AppStyles.p1,
          ),
        ),
        ...optic.shops.first.phones.map(
          (phone) => Flexible(
            child: GestureDetector(
              onTap: () => Utils.tryLaunchUrl(
                rawUrl: phone,
                isPhone: true,
              ),
              child: Text(
                phone,
                style: AppStyles.p1.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.turquoiseBlue,
                  decorationThickness: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

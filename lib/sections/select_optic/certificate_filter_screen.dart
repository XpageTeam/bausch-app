import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class CertificateFilterScreen extends StatefulWidget {
  final List<bool> typesStatus;
  final List<bool> additionalFilters;
  final void Function(List<bool> typesStatus, List<bool> additionalFilters)
      onSendUpdate;
  const CertificateFilterScreen({
    required this.typesStatus,
    required this.onSendUpdate,
    required this.additionalFilters,
    Key? key,
  }) : super(key: key);

  @override
  _CertificateFilterScreenState createState() =>
      _CertificateFilterScreenState();
}

class _CertificateFilterScreenState extends State<CertificateFilterScreen> {
  late final List<bool> currentTypes;
  late final List<bool> currentAdditions;
  @override
  void initState() {
    currentTypes = [...widget.typesStatus];
    currentAdditions = [...widget.additionalFilters];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Фильтры',
        backgroundColor: AppTheme.mystic,
        topRightWidget: TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            widget.onSendUpdate([false, false, false], [false, false]);
            Navigator.of(context).pop();
          },
          // TODO(all): сбросить сюда не влезает
          child: const Text(
            'Сброс',
            style: AppStyles.p1,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 26,
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
        ),
        child: BlueButtonWithText(
          text: 'Показать 2 варианта',
          onPressed: () {
            widget.onSendUpdate(
              currentTypes,
              currentAdditions,
            );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 23, bottom: 4),
              child: WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: Row(
                  children: [
                    CustomCheckbox(
                      value: currentAdditions[0],
                      onChanged: (value) {
                        currentAdditions[0] = value!;
                      },
                      borderRadius: 2,
                    ),
                    const Text(
                      'Ведётся приём детей до 18 лет',
                      style: AppStyles.h2,
                    ),
                  ],
                ),
              ),
            ),
            WhiteContainerWithRoundedCorners(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
              ),
              child: Row(
                children: [
                  CustomCheckbox(
                    value: currentAdditions[1],
                    onChanged: (value) {
                      currentAdditions[1] = value!;
                    },
                    borderRadius: 2,
                  ),
                  const Text(
                    'Скидка после подбора',
                    style: AppStyles.h2,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              child: Text(
                'Подбор линз',
                style: AppStyles.h1,
              ),
            ),
            WhiteContainerWithRoundedCorners(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomCheckbox(
                        value: currentTypes[0],
                        onChanged: (value) {
                          currentTypes[0] = value!;
                        },
                        borderRadius: 2,
                      ),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: AppTheme.turquoiseBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Сферические',
                        style: AppStyles.h2,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CustomCheckbox(
                          value: currentTypes[1],
                          onChanged: (value) {
                            currentTypes[1] = value!;
                          },
                          borderRadius: 2,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: AppTheme.sulu,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Мультифокальные',
                          style: AppStyles.h2,
                        ),
                        const Text(
                          ' (пресбиопия)',
                          style: AppStyles.h2GreyBold,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      CustomCheckbox(
                        value: currentTypes[2],
                        onChanged: (value) {
                          currentTypes[2] = value!;
                        },
                        borderRadius: 2,
                      ),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Торические',
                        style: AppStyles.h2,
                      ),
                      const Text(
                        ' (астигматизм)',
                        style: AppStyles.h2GreyBold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

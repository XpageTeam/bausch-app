import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class LensesHistory extends StatefulWidget {
  final Future<void> Function() expandList;
  final List<LensesWornHistoryModel> wornHistoryList;
  const LensesHistory({
    required this.wornHistoryList,
    required this.expandList,
    super.key,
  });

  @override
  State<LensesHistory> createState() => _LensesHistoryState();
}

class _LensesHistoryState extends State<LensesHistory> {
  bool showAll = false;
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'История ношения',
          style: AppStyles.h1,
        ),
        const SizedBox(height: 20),
        if (isUpdating)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(
              child: AnimatedLoader(),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: widget.wornHistoryList.isNotEmpty
                    ? WhiteContainerWithRoundedCorners(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: StaticData.sidePadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Text(
                                      'Надеты',
                                      style: AppStyles.p1Grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 40),
                                    child: Text(
                                      'Сняты',
                                      style: AppStyles.p1Grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: !showAll &&
                                        widget.wornHistoryList.length > 6
                                    ? 16
                                    : 0,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: showAll ||
                                        widget.wornHistoryList.length <= 6
                                    ? widget.wornHistoryList.length
                                    : 6,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: widget.wornHistoryList[index]
                                              .leftRight !=
                                          null
                                      ? _LeftRightRow(
                                          item: widget.wornHistoryList[index],
                                        )
                                      : _GreyContainer(
                                          item: widget.wornHistoryList[index],
                                        ),
                                ),
                              ),
                            ),
                            if (!showAll && widget.wornHistoryList.length > 6)
                              GreyButton(
                                text: 'Ранее',
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: StaticData.sidePadding,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isUpdating = true;
                                  });
                                  await widget.expandList();
                                  setState(() {
                                    showAll = true;
                                    isUpdating = false;
                                  });
                                },
                              ),
                          ],
                        ),
                      )
                    : const WhiteContainerWithRoundedCorners(
                        padding: EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: StaticData.sidePadding,
                        ),
                        child: Text(
                          'Покажем, когда вы надели и сняли линзы',
                          style: AppStyles.p1Grey,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LeftRightRow extends StatelessWidget {
  final LensesWornHistoryModel item;
  const _LeftRightRow({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(StaticData.sidePadding),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: DottedLine(
                  lineLength: MediaQuery.of(context).size.width / 3,
                  dashColor: AppTheme.grey,
                  dashLength: 2,
                  dashGapLength: 2,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WhiteContainerWithRoundedCorners(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/halfed_circle.png',
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(width: 8),
                            Center(
                              child: Text(
                                '${item.dateStartL!.day} ${HelpFunctions.getMonthNameByNumber(item.dateStartL!.month)}, ${item.dateStartL!.hour < 10 ? 0 : ''}${item.dateStartL!.hour}:${item.dateStartL!.minute < 10 ? 0 : ''}${item.dateStartL!.minute}',
                                style: AppStyles.p1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 8, height: 10, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: WhiteContainerWithRoundedCorners(
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        if (item.dateEndL != null)
                          Text(
                            '${item.dateEndL!.day} ${HelpFunctions.getMonthNameByNumber(item.dateEndL!.month)}, ${item.dateEndL!.hour < 10 ? 0 : ''}${item.dateEndL!.hour}:${item.dateEndL!.minute < 10 ? 0 : ''}${item.dateEndL!.minute}',
                            style: AppStyles.p1,
                            textAlign: TextAlign.left,
                          )
                        else
                          Container(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GreyContainer extends StatelessWidget {
  final LensesWornHistoryModel item;
  const _GreyContainer({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppTheme.mystic,
      ),
      child: Padding(
        padding: const EdgeInsets.all(StaticData.sidePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.left != null)
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: DottedLine(
                        lineLength: MediaQuery.of(context).size.width / 3,
                        dashColor: AppTheme.grey,
                        dashLength: 2,
                        dashGapLength: 2,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ColoredBox(
                              color: AppTheme.mystic,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.turquoiseBlue,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'L',
                                        style: AppStyles.n1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Center(
                                    child: Text(
                                      '${item.dateStartL!.day} ${HelpFunctions.getMonthNameByNumber(item.dateStartL!.month)}, ${item.dateStartL!.hour < 10 ? 0 : ''}${item.dateStartL!.hour}:${item.dateStartL!.minute < 10 ? 0 : ''}${item.dateStartL!.minute}',
                                      style: AppStyles.p1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 10,
                              color: AppTheme.mystic,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ColoredBox(
                          color: AppTheme.mystic,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              if (item.dateEndL != null)
                                Text(
                                  '${item.dateEndL!.day} ${HelpFunctions.getMonthNameByNumber(item.dateEndL!.month)}, ${item.dateEndL!.hour < 10 ? 0 : ''}${item.dateEndL!.hour}:${item.dateEndL!.minute < 10 ? 0 : ''}${item.dateEndL!.minute}',
                                  style: AppStyles.p1,
                                )
                              else
                                Container(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (item.right != null && item.left != null)
              const SizedBox(height: StaticData.sidePadding * 2),
            if (item.right != null)
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: DottedLine(
                        lineLength: MediaQuery.of(context).size.width / 3,
                        dashColor: AppTheme.grey,
                        dashLength: 2,
                        dashGapLength: 2,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ColoredBox(
                              color: AppTheme.mystic,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.sulu,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'R',
                                        style: AppStyles.n1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Center(
                                    child: Text(
                                      '${item.dateStartR!.day} ${HelpFunctions.getMonthNameByNumber(item.dateStartR!.month)}, ${item.dateStartR!.hour < 10 ? 0 : ''}${item.dateStartR!.hour}:${item.dateStartR!.minute < 10 ? 0 : ''}${item.dateStartR!.minute}',
                                      style: AppStyles.p1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 10,
                              color: AppTheme.mystic,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ColoredBox(
                          color: AppTheme.mystic,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              if (item.dateEndL != null)
                                Text(
                                  '${item.dateEndR!.day} ${HelpFunctions.getMonthNameByNumber(item.dateEndR!.month)}, ${item.dateEndR!.hour < 10 ? 0 : ''}${item.dateEndR!.hour}:${item.dateEndR!.minute < 10 ? 0 : ''}${item.dateEndR!.minute}',
                                  style: AppStyles.p1,
                                )
                              else
                                Container(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

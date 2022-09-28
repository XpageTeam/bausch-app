import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/my_lenses/lenses_worn_history_list_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
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
        Row(
          children: [
            Expanded(
              child: widget.wornHistoryList.isNotEmpty
                  ? WhiteContainerWithRoundedCorners(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
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
                                  padding: EdgeInsets.only(left:12),
                                  child: Text(
                                    'Надеты',
                                    style: AppStyles.p1Grey,
                        
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left:40),
                                  child: Text(
                                    'Сняты',
                                    style: AppStyles.p1Grey,
                                  
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.wornHistoryList.length,
                            // TODO(pavlov): листам поставить неверскролабл
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              // TODO(all): у непарных записей должен быть серый фон
                              child: ColoredBox(
                                color: widget.wornHistoryList[index].eye != 'LR'
                                    ? AppTheme.mystic
                                    : Colors.white,
                                child: Row(
                                  children: [
                                    if (widget.wornHistoryList[index].eye ==
                                        'LR')
                                      Image.asset(
                                        'assets/icons/halfed_circle.png',
                                        height: 16,
                                        width: 16,
                                      )
                                    else
                                      Container(
                                        height: 16,
                                        width: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.wornHistoryList[index]
                                                      .eye ==
                                                  'L'
                                              ? AppTheme.turquoiseBlue
                                              : AppTheme.sulu,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.wornHistoryList[index].eye,
                                            style: AppStyles.n1,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    Center(
                                      child: Text(
                                        HelpFunctions.formatDateRu(
                                          date: widget
                                              .wornHistoryList[index].dateStart,
                                        ),
                                        style: AppStyles.p1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Image.asset(
                                        'assets/line_dots.png',
                                        scale: 4.1,
                                      ),
                                    ),
                                    Center(
                                      child: widget.wornHistoryList[index]
                                                  .dateEnd !=
                                              null
                                          ? Text(
                                              HelpFunctions.formatDateRu(
                                                date: widget
                                                    .wornHistoryList[index]
                                                    .dateEnd!,
                                              ),
                                              style: AppStyles.p1,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (!showAll)
                            GreyButton(
                              text: 'Ранее',
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: StaticData.sidePadding,
                              ),
                              onPressed: () async {
                                setState(() {
                                  showAll = true;
                                });
                                await widget.expandList();
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
                        'Покажем когда вы надели и сняли линзы',
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

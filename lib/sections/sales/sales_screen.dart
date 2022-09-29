import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/sections/sales_section.dart';
import 'package:bausch/sections/home/widgets/containers/sales_wide_container.dart';
import 'package:bausch/sections/home/widgets/containers/small_container.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  final List<BaseCatalogSheetModel> salesList;
  const SalesScreen({required this.salesList, Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<BaseCatalogSheetModel> activeList = [];
  int activeFilterId = 0;

  @override
  void initState() {
    activeList = [...widget.salesList];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SalesScreen oldWidget) {
    activeList = [...oldWidget.salesList];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Скидки за баллы',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: LayoutBuilder(
          builder: (_, c) {
            final smallContainersRowsLength = (activeList.length / 2).ceil();
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                    ),
                    child: _FilterSection(
                      activeIndex: activeFilterId,
                      onTap: (newFilterId) => setState(() {
                        activeFilterId = newFilterId;
                        activeList = newFilterId == 0
                            ? widget.salesList
                            : widget.salesList
                                .where(
                                  (element) => element.type.contains(
                                    newFilterId == 1 ? 'offline' : 'online',
                                  ),
                                )
                                .toList();
                      }),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      WideSaleContainer(
                        item: activeList.first,
                        width: c.maxWidth,
                      ),
                      ...List.generate(
                        smallContainersRowsLength - 1,
                        (i) {
                          final leftIndex = 1 + i * 2;
                          final rightIndex = 1 + i * 2 + 1;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: _SmallContainerRow(
                              items: [
                                activeList[leftIndex],
                                if (rightIndex < activeList.length)
                                  activeList[rightIndex],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Wrap(
                  //   spacing: 4,
                  //   runSpacing: 4,
                  //   children: List.generate(activeList.length, (index) {
                  //     final item = activeList[index];
                  //     if (index == 0) {
                  //       return WideSaleContainer(
                  //         item: item,
                  //         width: c.maxWidth,
                  //       );
                  //     }
                  //     return _SmallContainer(
                  //       item: item,
                  //     );

                  //     // SmallContainer(
                  //     //   model: item as CatalogSheetModel,
                  //     //   sale: true,
                  //     // );
                  //   }),
                  // ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SmallContainerRow extends StatelessWidget {
  final List<BaseCatalogSheetModel> items;

  const _SmallContainerRow({
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _SmallContainer(
              item: items[0],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: items.length > 1
                ? _SmallContainer(
                    item: items[1],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _SmallContainer extends StatefulWidget {
  final BaseCatalogSheetModel item;
  const _SmallContainer({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<_SmallContainer> createState() => __SmallContainerState();
}

class __SmallContainerState extends State<_SmallContainer> {
  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      padding: EdgeInsets.only(
        top: 20,
        bottom: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.item.name,
              style: AppStyles.h2Bold,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.count.toString(),
                  style: AppStyles.p1,
                ),
                Container(
                  height: 85,
                  width: 80,
                  alignment: Alignment.bottomRight,
                  child: Image.network(
                    widget.item.icon ?? '',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _FilterSection({
    required this.activeIndex,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onTap(0),
          // () {
          //   setState(() {
          //     containerId = -1;
          //     activeFilterId = 0;
          //     activeList = [...widget.salesList];
          //   });
          // },
          child: WhiteContainerWithRoundedCorners(
            color: activeIndex == 0 ? Colors.white : Colors.transparent,
            child: const Text(
              'Все',
              style: AppStyles.h2,
            ),
            padding: const EdgeInsets.all(10),
          ),
        ),
        GestureDetector(
          onTap: () => onTap(1),
          // () {
          //   setState(() {
          //     containerId = -1;
          //     activeFilterId = 1;
          //     activeList = [
          //       ...widget.salesList.where(
          //         (element) => element.type.contains('offline'),
          //       ),
          //     ];
          //   });
          // },
          child: WhiteContainerWithRoundedCorners(
            color: activeIndex == 1 ? Colors.white : Colors.transparent,
            child: const Text(
              'В оффлайн',
              style: AppStyles.h2,
            ),
            padding: const EdgeInsets.all(10),
          ),
        ),
        GestureDetector(
          onTap: () => onTap(2),

          // () {
          //   setState(() {
          //     containerId = -1;
          //     activeFilterId = 2;
          //     activeList = [
          //       ...widget.salesList.where(
          //         (element) => element.type.contains('online'),
          //       ),
          //     ];
          //   });
          // },
          child: WhiteContainerWithRoundedCorners(
            color: activeIndex == 2 ? Colors.white : Colors.transparent,
            child: const Text(
              'В онлайн',
              style: AppStyles.h2,
            ),
            padding: const EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }
}

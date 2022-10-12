import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/home/sections/sales_section.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/only_bottom_bouncing_scroll_physics.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            final smallContainersRowsLength =
                ((activeList.length - 1) / 2).ceil();
            return CustomScrollView(
              scrollBehavior: const AntiGlowBehavior(),
              physics: const OnlyBottomBouncingScrollPhysics(),
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
                        smallContainersRowsLength,
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
  late CatalogItemCubit catalogItemCubit;

  @override
  void initState() {
    super.initState();
    catalogItemCubit = CatalogItemCubit(section: widget.item.type);
  }

  @override
  void didUpdateWidget(covariant _SmallContainer oldWidget) {
    if (oldWidget.item != widget.item) {
      catalogItemCubit = CatalogItemCubit(section: widget.item.type);
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  void dispose() {
    catalogItemCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: catalogItemCubit,
      child: SheetListener(
        model: widget.item,
        child: WhiteContainerWithRoundedCorners(
          onTap: catalogItemCubit.loadData,
          padding: const EdgeInsets.only(top: 20, bottom: 14),
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
              const Expanded(
                child: SizedBox(height: 14),
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
                      // height: 85,
                      width: 80,
                      // alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: widget.item.secondIcon == null &&
                              widget.item.icon == null
                          ? const SizedBox()
                          : ExtendedImage.network(
                              widget.item.secondIcon ?? widget.item.icon ?? '',
                              loadStateChanged: _onChangeState,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _onChangeState(ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.loading) {
      return const SizedBox();
    }
    if (state.extendedImageLoadState == LoadState.failed) {
      return const SizedBox();
    }
    return null;
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

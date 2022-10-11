import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SalesWidget extends StatelessWidget {
  final List<BaseCatalogSheetModel> catalogList;
  final List<BaseCatalogSheetModel> actualList = [];
  SalesWidget({required this.catalogList, Key? key}) : super(key: key) {
    // обрабатываем скидки за баллы
    for (final element in catalogList) {
      if (element.type.contains('offline') || element.type.contains('online')) {
        actualList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Скидки за баллы',
                style: AppStyles.h1,
              ),
              CustomTextButton(
                title: 'Все',
                titleStyle: AppStyles.h2,
                arrowSize: 14,
                onPressed: () =>
                    Navigator.of(Keys.mainContentNav.currentContext!).pushNamed(
                  '/sales',
                  arguments: actualList,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                actualList.length,
                (index) {
                  final item = actualList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? StaticData.sidePadding : 4,
                      right: index == actualList.length - 1
                          ? StaticData.sidePadding
                          : 0,
                    ),
                    child: index < 3
                        ? WideSaleContainer(
                            item: item,
                          )
                        : index == 3
                            ? _ShowAllContainer(
                                onTap: () => Navigator.of(
                                  Keys.mainContentNav.currentContext!,
                                ).pushNamed(
                                  '/sales',
                                  arguments: actualList,
                                ),
                              )
                            : const SizedBox(),
                  );
                },
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: height * 0.93,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: actualList.length,
        //     physics: const BouncingScrollPhysics(),
        //     itemBuilder: (_, index) {
        //       return Padding(
        //         padding: EdgeInsets.only(
        //           left: index == 0 ? StaticData.sidePadding : 0,
        //           right: index == actualList.length - 1
        //               ? StaticData.sidePadding
        //               : 4,
        //         ),
        //         child: index < 3
        //             ? SaleWideContainer(
        //                 width: (MediaQuery.of(context).size.width / 2 -
        //                         StaticData.sidePadding -
        //                         2) *
        //                     1.7,
        //                 model: actualList[index] as CatalogSheetModel,
        //               )
        //             : index == 3
        //                 ? WhiteContainerWithRoundedCorners(
        //                     width: 223,
        //                     onTap: () => Navigator.of(
        //                       Keys.mainContentNav.currentContext!,
        //                     ).pushNamed(
        //                       '/sales',
        //                       arguments: actualList,
        //                     ),
        //                     child: Center(
        //                       child: Column(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           Container(
        //                             height: 44,
        //                             width: 44,
        //                             decoration: BoxDecoration(
        //                               color: AppTheme.mystic,
        //                               borderRadius: BorderRadius.circular(22),
        //                             ),
        //                             child: Icon(
        //                               Icons.keyboard_arrow_right_outlined,
        //                             ),
        //                           ),
        //                           const SizedBox(
        //                             height: 10,
        //                           ),
        //                           const Text(
        //                             'Показать все',
        //                             textAlign: TextAlign.center,
        //                             style: AppStyles.h2,
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   )
        //                 : const SizedBox(),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class WideSaleContainer extends StatefulWidget {
  final BaseCatalogSheetModel item;
  final double width;
  const WideSaleContainer({
    required this.item,
    this.width = 317,
    Key? key,
  }) : super(key: key);

  @override
  State<WideSaleContainer> createState() => _WideSaleContainerState();
}

class _WideSaleContainerState extends State<WideSaleContainer> {
  late CatalogItemCubit catalogItemCubit;

  @override
  void initState() {
    super.initState();
    catalogItemCubit = CatalogItemCubit(section: widget.item.type);
  }

  @override
  void didUpdateWidget(covariant WideSaleContainer oldWidget) {
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
          width: widget.width,
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      bottom: 14.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TODO(all): из этого имени цеплять число для скидок
                        Text(
                          widget.item.name,
                          style: AppStyles.h2Bold,
                        ),
                        Text(
                          widget.item.count.toString(),
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 43),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.topRight,
                    height: 114,
                    width: 127,
                    child: Image.network(
                      widget.item.secondIcon ?? widget.item.icon ?? '',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShowAllContainer extends StatelessWidget {
  final VoidCallback onTap;

  const _ShowAllContainer({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      width: 173,
      height: 130,
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppTheme.mystic,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.keyboard_arrow_right_outlined,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Показать все',
              textAlign: TextAlign.center,
              style: AppStyles.h2,
            ),
          ],
        ),
      ),
    );
  }
}

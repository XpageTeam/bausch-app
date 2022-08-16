import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/small_container.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/containers/wide_container_without_items.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SalesWidget extends StatelessWidget {
  final List<BaseCatalogSheetModel> catalogList;
  List<BaseCatalogSheetModel> actualList = [];
  SalesWidget({required this.catalogList, Key? key}) : super(key: key) {
    for (final element in catalogList) {
      if (element.type == 'offline' || element.type == 'onlineShop') {
        actualList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: StaticData.sidePadding),
          child: Text(
            'Скидки за баллы',
            style: AppStyles.h1,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: height * 0.9,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actualList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? StaticData.sidePadding : 0,
                  right: index == actualList.length - 1
                      ? StaticData.sidePadding
                      : 4,
                ),
                // child: WideContainerWithoutItems(
                //   model: actualList[index] as CatalogSheetModel,
                // ),

                child: _SaleContainer(
                  model: actualList[index] as CatalogSheetModel,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SaleContainer extends StatefulWidget implements ContainerInterface {
  @override
  final CatalogSheetModel model;
  const _SaleContainer({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  State<_SaleContainer> createState() => _SaleContainerState();
}

class _SaleContainerState extends State<_SaleContainer> {
  late CatalogItemCubit catalogItemCubit;

  @override
  void initState() {
    super.initState();
    catalogItemCubit = CatalogItemCubit(section: widget.model.type);
  }

  @override
  void dispose() {
    super.dispose();
    catalogItemCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2;

    return BlocProvider(
      create: (context) => catalogItemCubit,
      child: SheetListener(
        model: widget.model,
        child: WhiteContainerWithRoundedCorners(
          onTap: () {
            //showSheetWithItems(context, model);
            catalogItemCubit.loadData();
          },
          width: width * 1.7,
          padding: const EdgeInsets.only(
            left: StaticData.sidePadding,
            right: 9,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.model.name,
                          style: AppStyles.h2,
                        ),
                        Text(
                          widget.model.count.toString(),
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.asset(
                      setTheImg(widget.model.type),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

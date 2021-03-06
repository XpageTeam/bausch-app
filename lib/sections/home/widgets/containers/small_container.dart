// ignore_for_file: unused_import

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/sections/sheets/widgets/providers/sheet_providers.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallContainer extends StatefulWidget implements ContainerInterface {
  @override
  final CatalogSheetModel model;
  const SmallContainer({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  State<SmallContainer> createState() => _SmallContainerState();
}

class _SmallContainerState extends State<SmallContainer> {
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
    final deviceWidth = MediaQuery.of(context).size.width;
    final width = deviceWidth / 2 - StaticData.sidePadding - 2;

    return BlocProvider(
      create: (context) => catalogItemCubit,
      child: SheetListener(
        model: widget.model,
        child: WhiteContainerWithRoundedCorners(
          onTap: () {
            //showSheetWithItems(context, model);
            catalogItemCubit.loadData();
          },
          heigth: width,
          width: width,
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 14,
            left: StaticData.sidePadding,
            right: StaticData.sidePadding,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Text(
                widget.model.name,
                style: AppStyles.h2,
                overflow: TextOverflow.visible,
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Text(
                  widget.model.count.toString(),
                  style: AppStyles.p1,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.6),
                      child: Image.asset(
                        setTheImg(widget.model.type),
                        height: deviceWidth < 350 ? 35 : 53,
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
}

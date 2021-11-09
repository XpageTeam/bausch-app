// ignore_for_file: unused_import

import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WideContainerWithItems extends StatefulWidget
    implements ContainerInterface {
  final String? subtitle;

  @override
  final CatalogSheetWithLogosModel model;

  const WideContainerWithItems({
    required this.model,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  State<WideContainerWithItems> createState() => _WideContainerWithItemsState();
}

class _WideContainerWithItemsState extends State<WideContainerWithItems> {
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
    return BlocProvider(
      create: (context) => catalogItemCubit,
      child: SheetListener(
        model: widget.model,
        child: WhiteContainerWithRoundedCorners(
          onTap: () {
            catalogItemCubit.loadData();
          },
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.model.name,
                style: AppStyles.h2Bold,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.subtitle ??
                          'Скидка на выбранный товар будет дейстовать в любой из оптик сети',
                      style: AppStyles.p1,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Image.network(
                    widget.model.icon,
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              if (widget.model.logos != null)
                Center(
                  child: SizedBox(
                    height: 32,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Image.network(
                          widget.model.logos![i],
                          width: 100,
                        );
                      },
                      separatorBuilder: (context, i) {
                        return const VerticalDivider();
                      },
                      itemCount: widget.model.logos!.length,
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

//const EdgeInsets.symmetric(horizontal: 12, vertical: 20),

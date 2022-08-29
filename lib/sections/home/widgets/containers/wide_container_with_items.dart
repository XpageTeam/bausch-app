// ignore_for_file: unused_import, prefer_is_empty

import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/sections/home/widgets/containers/container_interface.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:extended_image/extended_image.dart';
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
                style: AppStyles.h2,
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
                  Image.asset(
                    setTheImg(widget.model.type),
                    height: 45,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              if (widget.model.logos != null && widget.model.logos!.isNotEmpty)
                Center(
                  child: SizedBox(
                    height: 32,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 3.7,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        if (widget.model.logos!.length >= 1)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 20,
                            ),
                            child: ExtendedImage.network(
                              widget.model.logos![0],
                              printError: false,
                              loadStateChanged: loadStateChangedFunction,
                            ),
                          ),
                        // if (widget.model.logos!.length >= 1)
                        //   Expanded(
                        //     child: Center(
                        //       child: Container(
                        //         color: AppTheme.mystic,
                        //         width: 2,
                        //         height: 32,
                        //       ),
                        //     ),
                        //   ),
                        if (widget.model.logos!.length >= 2)
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                vertical: BorderSide(
                                  width: 2,
                                  color: AppTheme.mystic,
                                ),
                              ),
                            ),
                            child: ExtendedImage.network(
                              widget.model.logos![1],
                              printError: false,
                              loadStateChanged: loadStateChangedFunction,
                            ),
                          ),
                        // if (widget.model.logos!.length >= 2)
                        //   Expanded(
                        //     child: Center(
                        //       child: Container(
                        //         color: AppTheme.mystic,
                        //         width: 2,
                        //         height: 32,
                        //       ),
                        //     ),
                        //   ),
                        if (widget.model.logos!.length >= 3)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 20,
                            ),
                            child: ExtendedImage.network(
                              widget.model.logos![2],
                              printError: false,
                              loadStateChanged: loadStateChangedFunction,
                            ),
                          ),
                      ],
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

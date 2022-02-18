import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_methods.dart';
import 'package:bausch/sections/home/sections/may_be_interesting_wm.dart';
import 'package:bausch/sections/home/widgets/simple_slider/simple_slider.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/widgets/listeners/sheet_listener.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MayBeInteresting extends CoreMwwmWidget<MayBeInterestingWM> {
  final String text;
  MayBeInteresting({required this.text, Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => MayBeInterestingWM(
            context: context,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<MayBeInterestingWM>, MayBeInterestingWM>
      createWidgetState() => _MayBeInterestingState();
}

class _MayBeInterestingState
    extends WidgetState<MayBeInteresting, MayBeInterestingWM> {
  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<List<CatalogItemModel>>(
      streamedState: wm.catalogItems,
      loadingChild: const Center(
        child: AnimatedLoader(),
      ),
      builder: (_, items) {
        if (items.isEmpty) return const SizedBox();

        return Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text,
                style: AppStyles.h1,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // // Слайдер с товаром
            // ItemSlider<CatalogItemModel>(
            //   items: items,
            //   itemBuilder: (context, model) => CatalogItem(
            //     model: model,
            //     onTap: () => wm.onTapAction(model),
            //   ),
            //   indicatorBuilder: (context, isActive) => Indicator(
            //     isActive: isActive,
            //     animationDuration: const Duration(milliseconds: 300),
            //   ),
            // ),
            SimpleSlider<CatalogItemModel>(
              items: items,
              builder: (context, model) {
                final cubit = CatalogItemCubit(section: model.type!);
                return (model.isSection != null && model.isSection!)
                    ? BlocProvider(
                        create: (context) => cubit,
                        child: SheetListener(
                          model: sheetModel(model),
                          child: CatalogItem(
                            model: model,
                            onTap: cubit.loadData,
                          ),
                        ),
                      )
                    : CatalogItem(
                        model: model,
                        onTap: () => wm.onTapAction(model),
                      );
              },
            ),
          ],
        );
      },
    );
  }
}

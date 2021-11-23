// ignore_for_file: unused_import

import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/sections/home/cubit/catalogsheet_cubit.dart';
import 'package:bausch/sections/home/widgets/containers/small_container.dart';
import 'package:bausch/sections/home/widgets/containers/wide_container_with_items.dart';
import 'package:bausch/sections/home/widgets/containers/wide_container_without_items.dart';
import 'package:bausch/sections/sheets/widgets/providers/sheet_providers.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpendScores extends StatefulWidget {
  const SpendScores({Key? key}) : super(key: key);

  @override
  State<SpendScores> createState() => _SpendScoresState();
}

class _SpendScoresState extends State<SpendScores> {
  CatalogSheetCubit catalogSheetCubit = CatalogSheetCubit();

  @override
  void dispose() {
    super.dispose();
    catalogSheetCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogSheetCubit, CatalogSheetState>(
      bloc: catalogSheetCubit,
      builder: (context, state) {
        if (state is CatalogSheetSuccess) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Потратить баллы',
                style: AppStyles.h1,
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: Wrap(
                  //mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(
                    state.models.length,
                    (i) {
                      if (state.models[i].type == 'offline') {
                        return WideContainerWithItems(
                          model: state.models[i] as CatalogSheetWithLogosModel,
                        );
                      } else if (state.models[i].type ==
                          'online_consultation') {
                        return WideContainerWithoutItems(
                          model:
                              state.models[i] as CatalogSheetWithoutLogosModel,
                        );
                      } else {
                        return SmallContainer(
                          model: state.models[i] as CatalogSheetModel,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}

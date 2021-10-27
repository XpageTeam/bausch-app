import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_model.dart';
import 'package:bausch/models/sheets/catalog_sheet_with_logos.dart';
import 'package:bausch/sections/home/cubit/catalogsheet_cubit.dart';
import 'package:bausch/sections/home/widgets/small_container.dart';
import 'package:bausch/sections/home/widgets/wide_container_with_items.dart';
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
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogSheetCubit, CatalogSheetState>(
      bloc: catalogSheetCubit,
      builder: (context, state) {
        if (state is CatalogSheetSuccess) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Потратить баллы',
                style: AppStyles.h1,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  debugPrint(state.models.toString());
                },
                child: Text('123'),
              ),
              Flexible(
                child: Wrap(
                  //mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(
                    state.models.length,
                    (i) {
                      if ((state.models[i].type != 'offline') &&
                          (state.models[i].type != 'online_consultation')) {
                        return SmallContainer(
                          model: state.models[i] as CatalogSheetModel,
                        );
                      } else {
                        return WideContainerWithItems(
                          model: state.models[i] as CatalogSheetWithLogosModel,
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

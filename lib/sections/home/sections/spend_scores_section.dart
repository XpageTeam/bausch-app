import 'package:bausch/sections/home/cubit/catalogsheet_cubit.dart';
import 'package:bausch/sections/home/widgets/small_container.dart';
import 'package:bausch/sections/home/widgets/wide_container.dart';
import 'package:bausch/sections/home/widgets/wide_container_with_items.dart';
import 'package:bausch/test/models.dart';
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
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    (state.models.length % 2) == 0
                        ? state.models.length ~/ 2
                        : state.models.length ~/ 2 + 1,
                    (i) {
                      if ((state.models[i].type != 'shop') &&
                          (state.models[i].type != 'online_consultation')) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              SmallContainer(model: state.models[i * 2]),
                              const SizedBox(width: 4),
                              SmallContainer(model: state.models[i * 2 + 1]),
                            ],
                          ),
                        );
                      } else {
                        return Container();
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

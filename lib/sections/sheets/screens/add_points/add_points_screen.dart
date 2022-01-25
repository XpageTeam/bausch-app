import 'package:bausch/sections/sheets/screens/add_points/bloc/add_points/add_points_bloc.dart';
import 'package:bausch/sections/sheets/screens/add_points/widgets/add_item.dart';
import 'package:bausch/sections/sheets/screens/add_points/widgets/code_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* Add_points
//* list
class AddPointsScreen extends StatefulWidget {
  final ScrollController controller;
  const AddPointsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<AddPointsScreen> createState() => _AddPointsScreenState();
}

class _AddPointsScreenState extends State<AddPointsScreen> {
  final addPointsBloc = AddPointsBloc();

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      resizeToAvoidBottomInset: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
            bottom: 20,
            top: 66,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const CodeSection(),
              ],
            ),
          ),
        ),
        SliverAppBar(
          pinned: true,
          shadowColor: Colors.transparent,
          backgroundColor: AppTheme.mystic,
          collapsedHeight: 90,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: StaticData.sidePadding,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/add-points.png',
                  height: 66,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Добавить ещё',
                  style: AppStyles.h1,
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<AddPointsBloc, AddPointsState>(
          bloc: addPointsBloc,
          builder: (context, state) {
            if (state is AddPointsGetSuccess) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == state.models.length - 1
                              ? StaticData.sidePadding
                              : 4,
                        ),
                        child: AddItem(model: state.models[index]),
                      );
                    },
                    childCount: state.models.length,
                  ),
                ),
              );
            }
            if (state is AddPointsLoading) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Center(
                      child: AnimatedLoader(),
                    ),
                  ],
                ),
              );
            }
            return SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

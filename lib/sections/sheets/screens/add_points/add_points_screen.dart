import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/screens/add_points/widgets/add_item.dart';
import 'package:bausch/sections/sheets/screens/add_points/widgets/code_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

//* Add_points
//* list
class AddPointsScreen extends StatelessWidget {
  final ScrollController controller;
  const AddPointsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
            bottom: 40,
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
        SliverPadding(
          padding: const EdgeInsets.only(
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
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
                      style: AppStyles.h2,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
            bottom: 60,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: AddItem(model: Models.addItems[i]),
              ),
              childCount: Models.addItems.length,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//catalog_online_consultation
class ConsultationScreen extends StatefulWidget {
  final ScrollController controller;
  const ConsultationScreen({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final CatalogItemCubit catalogItemCubit =
      CatalogItemCubit(section: StaticData.types['consultation']!);
  late ConsultationItemModel model;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: BlocBuilder<CatalogItemCubit, CatalogItemState>(
          bloc: catalogItemCubit,
          builder: (context, state) {
            if (state is CatalogItemSuccess) {
              model = state.items[0] as ConsultationItemModel;

              return CustomScrollView(
                controller: widget.controller,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 12,
                      bottom: 4,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          TopSection.consultation(
                            state.items[0] as ConsultationItemModel,
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.lock_clock_sharp),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${(state.items[0] as ConsultationItemModel).length} минут',
                                    style: AppStyles.p1,
                                  ),
                                ],
                              ),
                            ),
                            widget.key,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const InfoSection(),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Warning.advertisment(),
                          const SizedBox(
                            height: 160,
                          ),
                        ],
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
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: 'Потратить баллы',
                onPressed: () {
                  Keys.bottomSheetWithoutItemsNav.currentState!.pushNamed(
                    '/verification_consultation',
                    arguments: SheetScreenArguments(model: model),
                  );
                },
              ),
            ),
            const InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

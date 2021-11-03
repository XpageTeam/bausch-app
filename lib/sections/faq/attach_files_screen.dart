import 'package:bausch/sections/faq/bloc/attach_bloc.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttachFilesScreen extends StatefulWidget {
  const AttachFilesScreen({Key? key}) : super(key: key);

  @override
  State<AttachFilesScreen> createState() => _AttachFilesScreenState();
}

class _AttachFilesScreenState extends State<AttachFilesScreen> {
  final AttachBloc attachBloc = AttachBloc();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: BlocBuilder<AttachBloc, AttachState>(
        bloc: attachBloc,
        builder: (context, state) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 14,
                          bottom: 30,
                        ),
                        child: DefaultAppBar(
                          title: 'Прикрепить файл',
                          backgroundColor: AppTheme.mystic,
                          topRightWidget: NormalIconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Keys.mainNav.currentState!.pop();
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: StaticData.sidePadding,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.add_circle_outline_rounded),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Прикрепить файл',
                                  style: AppStyles.h2,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is AttachAdded)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          return WhiteContainerWithRoundedCorners(
                            padding: const EdgeInsets.symmetric(vertical: 27),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 13),
                                  child: Icon(Icons.filter),
                                ),
                                Text(
                                  state.files[i],
                                  style: AppStyles.h2,
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: state.files.length,
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: 'Добавить',
                onPressed: () {
                  attachBloc.add(AttachAdd());
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

import 'package:bausch/sections/faq/bloc/attach/attach_bloc.dart';
import 'package:bausch/sections/faq/bloc/forms/fields_bloc.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class AttachFilesScreenArguments {
  final FieldsBloc fieldsBloc;

  AttachFilesScreenArguments({required this.fieldsBloc});
}

class AttachFilesScreen extends StatefulWidget
    implements AttachFilesScreenArguments {
  @override
  final FieldsBloc fieldsBloc;
  const AttachFilesScreen({
    required this.fieldsBloc,
    Key? key,
  }) : super(key: key);

  @override
  State<AttachFilesScreen> createState() => _AttachFilesScreenState();
}

class _AttachFilesScreenState extends State<AttachFilesScreen> {
  final AttachBloc attachBloc = AttachBloc();

  @override
  void dispose() {
    super.dispose();

    attachBloc.close();
  }

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
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: StaticData.sidePadding,
                        ),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                attachBloc.add(AttachAdd());
                              },
                              child: Row(
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: WhiteContainerWithRoundedCorners(
                              padding: const EdgeInsets.symmetric(vertical: 27),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 13),
                                    child: Icon(Icons.filter),
                                  ),
                                  Flexible(
                                    child: Text(
                                      basename(state.files[i].path),
                                      style: AppStyles.h2,
                                    ),
                                  ),
                                ],
                              ),
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
                  widget.fieldsBloc.add(FieldsAddFiles(files: state.files));
                  Navigator.of(context).pop();
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

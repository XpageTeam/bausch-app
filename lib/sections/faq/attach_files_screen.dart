import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/bloc/attach/attach_bloc.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class AttachFilesScreenArguments {
  final FormScreenWM formScreenWM;
  //final bool isExtra;
  final FieldModel fieldModel;

  AttachFilesScreenArguments({
    required this.formScreenWM,
    //required this.isExtra,
    required this.fieldModel,
  });
}

class AttachFilesScreen extends StatefulWidget
    implements AttachFilesScreenArguments {
  @override
  final FormScreenWM formScreenWM;
  // @override
  // final bool isExtra;
  @override
  final FieldModel fieldModel;
  const AttachFilesScreen({
    required this.formScreenWM,
    //required this.isExtra,
    required this.fieldModel,
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
  void initState() {
    super.initState();

    //attachBloc.add(AttachAddFromOutside(files: widget.fieldsBloc.state.files));
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
          debugPrint(state.files.toString());
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
                            onPressed: Keys.mainContentNav.currentState?.pop,
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
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: AppTheme.mineShaft,
                                  ),
                                  const SizedBox(
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                    ),
                                    child: ExtendedImage.asset(
                                      'assets/icons/document.png',
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      basename(
                                        state.files[i].name ?? 'Имя файла',
                                      ),
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
                  final files = [
                    ...widget.formScreenWM.extraList.value.data!.files,
                  ];

                  if (widget.fieldModel.type == 'file') {
                    widget.formScreenWM.extraList.value.data!.files
                        .addAll(state.files.map((file) {
                      return MapEntry(
                        'extra[${widget.fieldModel.xmlId}]',
                        dio.MultipartFile.fromFileSync(file.path!),
                      );
                    }).toList());
                    // map.addAll(
                    //   <String, dynamic>{
                    //     'extra[${widget.fieldModel.xmlId}]': ,
                    //   },
                    // );
                  } else {
                    widget.formScreenWM.extraList.value.data!.files
                        .addAll(state.files.map((file) {
                      return MapEntry(
                        'file[]',
                        dio.MultipartFile.fromFileSync(file.path!),
                      );
                    }).toList());
                    // map.addAll(
                    //   <String, dynamic>{
                    //     'file': state.files,
                    //   },
                    // );
                  }

                  final data = widget.formScreenWM.extraList.value.data!;

                  data.files.addAll(files);

                  final nData = dio.FormData();

                  nData.fields.addAll(data.fields);

                  nData.files.addAll(data.files);

                  widget.formScreenWM.extraList
                      .content(widget.formScreenWM.extraList.value.data!);
                  // ignore: use_build_context_synchronously
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

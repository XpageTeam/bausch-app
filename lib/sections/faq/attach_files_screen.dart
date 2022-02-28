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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    if (widget.formScreenWM.localFileStorage.isNotEmpty) {
      if (widget.fieldModel.type == 'file') {
        if (widget.formScreenWM.localFileStorage.containsKey(
          'extra[${widget.fieldModel.xmlId}][]',
        )) {
          attachBloc.add(
            AttachAddFromOutside(
              files: widget.formScreenWM
                      .localFileStorage['extra[${widget.fieldModel.xmlId}][]']
                  as List<PlatformFile>,
            ),
          );
        }
      } else {
        if (widget.formScreenWM.localFileStorage.containsKey(
          'file[]',
        )) {
          debugPrint(widget.formScreenWM.localFileStorage['file[]'].toString());
          attachBloc.add(
            AttachAddFromOutside(
              files: widget.formScreenWM.localFileStorage['file[]']
                  as List<PlatformFile>,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: BlocProvider(
        create: (context) => attachBloc,
        child: BlocListener<AttachBloc, AttachState>(
          listener: (context, state) {
            if (state is AttachRemoved) {
              _update(state.files);
            }
          },
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
                                onPressed:
                                    Keys.mainContentNav.currentState?.pop,
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
                                      Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: AppTheme.mineShaft,
                                      ),
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
                    if (state is AttachAdded || state is AttachRemoved)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: WhiteContainerWithRoundedCorners(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 27),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: ExtendedImage.asset(
                                                'assets/icons/document.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                state.files[i].name,
                                                style: AppStyles.h2,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            attachBloc
                                                .add(AttachRemove(index: i));
                                          },
                                          child: ExtendedImage.asset(
                                            'assets/icons/delete.png',
                                            width: 16,
                                            height: 16,
                                          ),
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
                      _update(state.files);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            },
          ),
        ),
      ),
    );
  }

  void _update(List<PlatformFile> files) {
    final m = <String, dynamic>{}
      ..addAll(widget.formScreenWM.extraList.value.data!);

    debugPrint('len: ${files.length}');

    if (widget.fieldModel.type == 'file') {
      if (files.isNotEmpty) {
        m.addAll(
          <String, dynamic>{
            'extra[${widget.fieldModel.xmlId}][]': files,
          },
        );
        widget.formScreenWM.localFileStorage.addAll(
          <String, List<PlatformFile>>{
            'extra[${widget.fieldModel.xmlId}][]': files,
          },
        );
      } else {
        m.remove('extra[${widget.fieldModel.xmlId}][]');
        widget.formScreenWM.localFileStorage
            .remove('extra[${widget.fieldModel.xmlId}][]');
      }
      widget.formScreenWM.extraList.content(m);
    } else {
      if (files.isNotEmpty) {
        m.addAll(
          <String, dynamic>{
            'file[]': files,
          },
        );
        widget.formScreenWM.localFileStorage.addAll(
          <String, List<PlatformFile>>{
            'file[]': files,
          },
        );
      } else {
        m.remove('file[]');

        widget.formScreenWM.localFileStorage.remove('file[]');
      }
      widget.formScreenWM.filesList.content(m);
    }
  }
}

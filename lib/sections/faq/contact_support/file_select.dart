import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/faq/attach_files_screen.dart';
import 'package:bausch/sections/faq/contact_support/wm/forms_screen_wm.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;

class FileSelect extends StatefulWidget {
  final FieldModel model;
  const FileSelect({required this.model, Key? key}) : super(key: key);

  @override
  State<FileSelect> createState() => _FileSelectState();
}

class _FileSelectState extends State<FileSelect> {
  late final FormScreenWM formScreenWM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formScreenWM = Provider.of<FormScreenWM>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: WhiteContainerWithRoundedCorners(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/add_files',
            arguments: AttachFilesScreenArguments(
              fieldModel: widget.model,
              formScreenWM: formScreenWM,
            ),
          );
        },
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
                widget.model.name,
                //widget.model.name,
                style: AppStyles.h2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

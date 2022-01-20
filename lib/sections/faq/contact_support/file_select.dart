import 'package:bausch/models/faq/forms/field_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/theme/styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class FileSelect extends StatelessWidget {
  final FieldModel model;
  const FileSelect({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                //basename(state.files[i].path),
                model.name,
                style: AppStyles.h2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

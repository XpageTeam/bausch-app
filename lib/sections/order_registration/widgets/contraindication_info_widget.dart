import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ContraindicationsInfoWidget extends StatelessWidget {
  const ContraindicationsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 8, 36, 19),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Flexible(
            child: Text(
              StaticData.contraindications,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.grey,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 16 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

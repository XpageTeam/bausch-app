import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//* Макет:
//* Loader:
//* loading
class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          color: AppTheme.mystic,
          child: const Center(
            child: AnimatedLoader(),
          ),
        ),
      ),
    );
  }
}

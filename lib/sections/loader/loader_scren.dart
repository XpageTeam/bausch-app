import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

//* Макет:
//* Loader:
//* loading
class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.mystic,
        child: const Center(
          child: AnimatedLoader(),
        ),
      ),
    );
  }
}

import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';

//* Макет:
//* Loader:
//* loading
class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: Container(
        color: AppTheme.mystic,
        child: const Center(
          child: AnimatedLoader(),
        ),
      ),
    );
  }
}

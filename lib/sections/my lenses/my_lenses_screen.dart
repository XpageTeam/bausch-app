import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class MyLensesScreen extends StatefulWidget {
  const MyLensesScreen({Key? key}) : super(key: key);

  @override
  State<MyLensesScreen> createState() => _MyLensesScreenState();
}

class _MyLensesScreenState extends State<MyLensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Мои линзы',
        backgroundColor: AppTheme.mystic,
      ),
      body: Container(),
    );
  }
}

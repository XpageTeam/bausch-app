import 'package:bausch/sections/shops/cubits/page_switcher_cubit/page_switcher_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageSwitcherCubitProvider extends StatefulWidget {
  final Widget Function(BuildContext) builder;
  const PageSwitcherCubitProvider({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _PageSwitcherCubitProviderState createState() =>
      _PageSwitcherCubitProviderState();
}

class _PageSwitcherCubitProviderState extends State<PageSwitcherCubitProvider> {
  final _pageSwitcherCubit = PageSwitcherCubit();

  @override
  void dispose() {
    _pageSwitcherCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _pageSwitcherCubit,
      child: Builder(
        builder: widget.builder,
      ),
    );
  }
}

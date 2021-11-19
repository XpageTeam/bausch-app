import 'package:bausch/sections/sheets/cubit/catalog_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SheetProviders extends StatefulWidget {
  final Widget child;
  final String section;
  const SheetProviders({required this.child, required this.section, Key? key})
      : super(key: key);

  @override
  _SheetProvidersState createState() => _SheetProvidersState();
}

class _SheetProvidersState extends State<SheetProviders> {
  late CatalogItemCubit catalogItemCubit;

  @override
  void initState() {
    super.initState();
    catalogItemCubit = CatalogItemCubit(section: widget.section);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => catalogItemCubit),
      ],
      child: widget.child,
    );
  }
}

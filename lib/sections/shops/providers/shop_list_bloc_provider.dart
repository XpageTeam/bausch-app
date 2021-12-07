import 'package:bausch/sections/shops/cubits/shop_list_cubit/shoplist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopListCubitProvider extends StatefulWidget {
  final Widget child;
  final String cityName;
  const ShopListCubitProvider({
    required this.cityName,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _ShopListCubitProviderState createState() => _ShopListCubitProviderState();
}

class _ShopListCubitProviderState extends State<ShopListCubitProvider> {
  final shopListCubit = ShopListCubit();
  @override
  void initState() {
    super.initState();
    shopListCubit.loadShopList();
    // shopListCubit.loadShopListByCity(
    //   widget.cityName,
    // );
  }

  @override
  void dispose() {
    shopListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => shopListCubit,
      child: widget.child,
    );
  }
}

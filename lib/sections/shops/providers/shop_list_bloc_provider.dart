import 'package:bausch/sections/shops/blocs/shop_list_bloc/shop_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopListBlocProvider extends StatefulWidget {
  final Widget child;
  const ShopListBlocProvider({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _ShopListBlocProviderState createState() => _ShopListBlocProviderState();
}

class _ShopListBlocProviderState extends State<ShopListBlocProvider> {
  final shopListBloc = ShopListBloc();
  @override
  void initState() {
    super.initState();
    shopListBloc.add(ShopsListLoad());
  }

  @override
  void dispose() {
    shopListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => shopListBloc,
      child: widget.child,
    );
  }
}

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/blocs/map_bloc/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef MapBlocCallback = Widget Function(BuildContext);

class MapBlocProvider extends StatefulWidget {
  final List<ShopModel> shopList;

  //* Сделал для того, чтобы получать контекст билдера в map_with_buttons
  final MapBlocCallback builder;
  const MapBlocProvider({
    required this.shopList,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _MapBlocProviderState createState() => _MapBlocProviderState();
}

class _MapBlocProviderState extends State<MapBlocProvider> {
  late final MapBloc mapBloc;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(shopList: widget.shopList);
  }

  @override
  void dispose() {
    debugPrint('map BLOC closed');
    mapBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => mapBloc,
      child: Builder(builder: widget.builder),
    );
  }
}

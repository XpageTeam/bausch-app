import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/home/widgets/default_catalog_item.dart';
import 'package:bausch/sections/home/widgets/slider/indicator_row.dart';
import 'package:flutter/material.dart';

class HomeScreenItemSlider extends StatefulWidget {
  final List<CatalogItemModel> modelList;
  const HomeScreenItemSlider({
    required this.modelList,
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenItemSliderState createState() => HomeScreenItemSliderState();
}

class HomeScreenItemSliderState extends State<HomeScreenItemSlider> {
  final controller = ScrollController();
  int currentIndex = 0;
  int count = 0;
  double value = 0.0;

  @override
  void initState() {
    super.initState();
    count = (widget.modelList.length % 2).isOdd
        ? widget.modelList.length ~/ 2 + 1
        : widget.modelList.length ~/ 2;

    controller.addListener(
      () {
        final oneContainerWidth = controller.position.maxScrollExtent / count;
        setState(
          () {
            currentIndex = controller.offset ~/ oneContainerWidth;
            currentIndex =
                currentIndex == count ? currentIndex - 1 : currentIndex;

            value = controller.offset;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: List<Widget>.generate(
                widget.modelList.length,
                (i) => DefaultCatalogItem(
                  model: widget.modelList[i],
                  rightMargin: widget.modelList.length - 1 == i ? 0 : 4,
                  // isProduct: true,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),

        // Индикатор текущей страницы
        IndicatorRow(
          currentIndex: currentIndex,
          count: count,
        ),
      ],
    );
  }
}

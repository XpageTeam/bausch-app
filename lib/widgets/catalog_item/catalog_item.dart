import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/screens/webinars/final_webinar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final CatalogItemModel model;
  final VoidCallback? onTap;
  const CatalogItem({
    required this.model,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: model is WebinarItemModel
          ? () => onWebinarClick(context, model as WebinarItemModel)
          : () => onTap?.call(),
      child: Padding(
        padding: const EdgeInsets.only(
          //right: 4,
          bottom: 4,
        ),
        child: Container(
          //padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width / 2 -
              StaticData.sidePadding -
              2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              if (model is! WebinarItemModel)
                const SizedBox(
                  height: 12,
                ),
              if (model is! WebinarItemModel)
                SizedBox(
                  height: 100,
                  child: AspectRatio(
                    aspectRatio: 37 / 12,
                    child: Image.network(
                      model.picture,
                    ),
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 174 / 112,
                  child: Image.network(model.picture),
                ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: Text(
                  model.name,
                  style: AppStyles.p1,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Expanded(
                child: SizedBox(
                  height: 16,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                    left: StaticData.sidePadding,
                  ),
                  child: model is WebinarItemModel
                      ? ButtonWithPoints(
                          withIcon: !(model as WebinarItemModel).canWatch,
                          price: (model as WebinarItemModel).canWatch
                              ? 'Просмотр'
                              : model.price.toString(),
                          onPressed: () => onWebinarClick(
                            context,
                            model as WebinarItemModel,
                          ),
                        )
                      : ButtonWithPoints(
                          price: model.price.toString(),
                          onPressed: () {
                            onTap?.call();
                          },
                        ),
                ),
              ),
              // const SizedBox(
              //   height: 16,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void onWebinarClick(BuildContext context, WebinarItemModel model) {
    if (model.canWatch) {
      showDialog<void>(
        context: context,
        builder: (context) => VimeoPopup(
          // TODO(Danil): массив id
          videoId: model.videoId.first,
        ),
      );
    } else {
      onTap?.call();
    }
  }
}

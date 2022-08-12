import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:bausch/widgets/custom_line_loading.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final CatalogItemModel model;
  final VoidCallback? onTap;
  final void Function(WebinarItemModel webinar)? allWebinarsCallback;
  const CatalogItem({
    required this.model,
    this.allWebinarsCallback,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: model is WebinarItemModel
          ? () => onWebinarClick(context, model as WebinarItemModel)
          : model is PartnersItemModel && (model as PartnersItemModel).isBought
              ? null
              : onTap,
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
            mainAxisAlignment: MainAxisAlignment.end,
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
                    child: model.picture != null
                        ? ExtendedImage.network(
                            model.picture!,
                            printError: false,
                            loadStateChanged: loadStateChangedFunction,
                          )
                        : null,
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 174 / 112,
                  child: model.picture != null
                      ? ExtendedImage.network(
                          model.picture!,
                          printError: false,
                          borderRadius: BorderRadius.circular(5),
                          loadStateChanged: loadStateChangedFunction,
                        )
                      : null,
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
              CustomLineLoadingIndicator(
                maximumScore: model.price,
                isInList: true,
              ),

              Padding(
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
                    : model is PartnersItemModel &&
                            (model as PartnersItemModel).isBought
                        ? ButtonWithPoints(
                            price: 'Куплено',
                            onPressed: () {},
                          )
                        : ButtonWithPoints(
                            price: model.priceToString,
                            onPressed: () {
                              onTap?.call();
                            },
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
      if (model.videoIds.length > 1) {
        allWebinarsCallback?.call(model);
      } else {
        showDialog<void>(
          context: context,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (context) => WebinarPopup(
            videoId: model.videoIds.first,
          ),
        );
      }
    } else {
      onTap?.call();
    }
  }
}

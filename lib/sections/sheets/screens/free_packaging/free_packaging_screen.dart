// import 'package:bausch/models/catalog_item/catalog_item_model.dart';
// import 'package:bausch/models/catalog_item/product_item_model.dart';
// import 'package:bausch/models/orders_data/order_data.dart';
// import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
// import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
// import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
// import 'package:bausch/sections/sheets/screens/free_packaging/widget_models/free_packaging_screen_wm.dart';
// import 'package:bausch/sections/sheets/sheet_screen.dart';
// import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
// import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
// import 'package:bausch/static/static_data.dart';
// import 'package:bausch/theme/app_theme.dart';
// import 'package:bausch/theme/styles.dart';
// import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
// import 'package:bausch/widgets/custom_line_loading.dart';
// import 'package:bausch/widgets/offers/offer_type.dart';
// import 'package:bausch/widgets/offers/offers_section.dart';
// import 'package:flutter/material.dart';
// import 'package:surf_mwwm/surf_mwwm.dart';

// //catalog_free_packaging
// class FreePackagingScreen extends CoreMwwmWidget<FreePackagingScreenWM>
//     implements ItemSheetScreenArguments {
//   final ScrollController controller;

//   @override
//   final CatalogItemModel model;

//   @override
//   final OrderData? orderData;
//   @override
//   final String? discount;

//   FreePackagingScreen({
//     required this.controller,
//     required this.model,
//     this.orderData,
//     this.discount,
//     Key? key,
//   }) : super(
//           key: key,
//           widgetModelBuilder: (context) => FreePackagingScreenWM(
//             context: context,
//             productItemModel: model as ProductItemModel,
//           ),
//         );

//   @override
//   WidgetState<CoreMwwmWidget<FreePackagingScreenWM>, FreePackagingScreenWM>
//       createWidgetState() => _FreePackagingScreenState();
// }

// class _FreePackagingScreenState
//     extends WidgetState<FreePackagingScreen, FreePackagingScreenWM> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomSheetScaffold(
//       backgroundColor: AppTheme.mystic,
//       controller: widget.controller,
//       onScrolled: (offset) {
//         if (offset > 60) {
//           wm.colorState.accept(AppTheme.turquoiseBlue);
//         } else {
//           wm.colorState.accept(AppTheme.mystic);
//         }
//       },
//       appBar: StreamedStateBuilder<Color>(
//         streamedState: wm.colorState,
//         builder: (_, color) {
//           return CustomSliverAppbar(
//             padding: const EdgeInsets.all(18),
//             icon: Container(
//               height: 1,
//             ),
//             iconColor: color,
//           );
//         },
//       ),
//       slivers: [
//         SliverPadding(
//           padding: const EdgeInsets.only(
//             top: 12,
//             left: 12,
//             right: 12,
//             bottom: 20,
//           ),
//           sliver: SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 TopSection.packaging(
//                   model: widget.model,
//                   key: widget.key,
//                   topLeftWidget: CustomLineLoadingIndicator(
//                     maximumScore: widget.model.price,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 InfoSection(
//                   text: widget.model.previewText,
//                   secondText: widget.model.detailText,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SliverPadding(
//           padding: const EdgeInsets.only(
//             bottom: 12,
//           ),
//           sliver: SliverToBoxAdapter(
//             child: OffersSection(
//               type: OfferType.freeProduct,
//             ),
//           ),
//         ),
//         SliverPadding(
//           padding: const EdgeInsets.fromLTRB(
//             StaticData.sidePadding,
//             0,
//             StaticData.sidePadding,
//             0,
//           ),
//           sliver: LegalInfo(
//             textStyle: AppStyles.p1.copyWith(
//               color: AppTheme.grey,
//             ),
//             texts: const [
//               'Адрес доставки должен быть на территории Российской Федерации, за исключением Республики Крым (по правилам программы доставка в Крым и Севастополь не осуществляется).',
//               'Бесплатная упаковка будет направлена на указанный адрес не позднее 60 рабочих дней с момента заказа.',
//               'Организатор не несёт ответственность за невозможность доставки в связи с некорректным указанием адреса доставки и в случае невозможности связаться с получателем по указанному номеру телефона. Сроки доставки определяются организацией, осуществляющей доставку.',
//               'Внешний вид и комплектность подарочных изделий могут отличаться от изображений на сайте.',
//             ],
//           ),
//         ),
//       ],
//       bottomNavBar: CustomFloatingActionButton(
//         text: wm.difference > 0 ? 'Накопить баллы' : 'Перейти к заказу',
//         icon: wm.difference > 0
//             ? const Icon(
//                 Icons.add,
//                 color: AppTheme.mineShaft,
//               )
//             : null,
//         onPressed: () {
//           wm.buttonAction();
//         },
//       ),
//     );
//   }
// }

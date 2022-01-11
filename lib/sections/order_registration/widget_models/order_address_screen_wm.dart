import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OrderAddressScreenWM extends WidgetModel {
  final BuildContext context;

  final OrderRegistrationScreenWM orderRegistrationScreenWM;

  final AdressModel adress;

  final loadingState = StreamedState<bool>(false);

  //final ProductItemModel productItemModel;

  final makeOrderAction = VoidAction();

  late TextEditingController flatController;
  late TextEditingController entryController;
  late TextEditingController floorController;

  late UserWM userWM;

  OrderAddressScreenWM({
    required this.context,
    required this.adress,
    //required this.productItemModel,
    required this.orderRegistrationScreenWM,
    //required this.productItemModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    userWM = Provider.of<UserWM>(
      context,
      listen: false,
    );

    super.onLoad();
  }

  @override
  void onBind() {
    flatController = TextEditingController(
      text: adress.flat == null ? '' : adress.flat.toString(),
    );

    entryController = TextEditingController(
      text: adress.entry == null ? '' : adress.entry.toString(),
    );

    floorController = TextEditingController(
      text: adress.floor == null ? '' : adress.floor.toString(),
    );

    makeOrderAction.bind((_) => _spendPoints());
    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    final updatedAdressModel = AdressModel(
      id: adress.id,
      street: adress.street,
      house: adress.house,
      flat: int.tryParse(flatController.text),
      entry: int.tryParse(entryController.text),
      floor: int.tryParse(floorController.text),
    );

    try {
      await AddressUpdater.update(updatedAdressModel);

      await OrderFreePackagingSaver.save(
        orderRegistrationScreenWM.productItemModel,
        updatedAdressModel,
        diopters: orderRegistrationScreenWM.diopters.value,
        cylinder: orderRegistrationScreenWM.cylinder.value,
        axis: orderRegistrationScreenWM.axis.value,
        addiction: orderRegistrationScreenWM.addidations.value,
        color: orderRegistrationScreenWM.color.value,
      );

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWM.userData.content(userRepository);

      await orderRegistrationScreenWM.updateUserData();
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      _showTopError(error);
    } else {
      await showFlexibleBottomSheet<void>(
        context: context,
        initHeight: 0.9,
        maxHeight: 0.9,
        builder: (ctx, controller, d) {
          return FinalFreePackaging(
            controller: ScrollController(),
            model: orderRegistrationScreenWM.productItemModel,
          );
        },
      );
    }
  }

  void _showTopError(CustomException ex) {
    showDefaultNotification(
      title: ex.title,
      subtitle: ex.subtitle,
    );
  }
}

// class OrderFreePackagingSaver {
//   static Future<BaseResponseRepository> save(
//     ProductItemModel model,
//     AdressModel address,
//   ) async {
//     final rh = RequestHandler();
//     final resp = await rh.put<Map<String, dynamic>>(
//       '/order/freePack/save/',
//       data: FormData.fromMap(
//         <String, dynamic>{
//           'productId': model.id,
//           'price': model.price,
//           'addressId': address.id,
//           'diopters': 0,
//           'cylinder': 0,
//           'axis': 0,
//           'addiction': 0,
//           'color': 0,
//         },
//       ),
//       options: rh.cacheOptions
//           ?.copyWith(
//             maxStale: const Duration(days: 1),
//             policy: CachePolicy.request,
//           )
//           .toOptions(),
//     );

//     final data = resp.data!;

//     return BaseResponseRepository.fromMap(data);
//   }
// }

class AddressUpdater {
  static Future<BaseResponseRepository> update(
    AdressModel address,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.put<Map<String, dynamic>>(
      '/user/address/${address.id}/',
      data: FormData.fromMap(
        <String, dynamic>{
          'street': address.street,
          'house': address.house,
          'flat': address.flat,
          'entry': address.entry,
          'floor': address.floor,
          'city': address.city,
        },
      ),
    );

    final data = resp.data!;

    return BaseResponseRepository.fromMap(data);
  }
}

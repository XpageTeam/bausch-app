import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/my_adresses_screen.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OrderRegistrationScreenWM extends WidgetModel {
  final BuildContext context;
  final ProductItemModel productItemModel;

  final buttonAction = VoidAction();

  final addAddressAction = VoidAction();

  final makeOrderAction = VoidAction();

  final loadingState = StreamedState<bool>(false);

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+0 000 000 00 00');

  late UserWM userWM;

  late AdressModel address;

  late AdressesCubit adressesCubit;

  late int difference;

  OrderRegistrationScreenWM({
    required this.context,
    required this.productItemModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    userWM = Provider.of<UserWM>(
      context,
      listen: false,
    );
    final points = userWM.userData.value.data?.balance.available.toInt() ?? 0;
    difference = points - productItemModel.price;

    super.onLoad();
  }

  @override
  void onBind() {
    userWM = Provider.of<UserWM>(context, listen: false);

    //emailController.text = userWM.userData.value.data!.user.email ?? '';
    nameController.text = userWM.userData.value.data!.user.name ?? '';
    lastNameController.text = userWM.userData.value.data!.user.lastName ?? '';
    phoneController.text = userWM.userData.value.data!.user.phone;

    addAddressAction.bind((_) {
      Navigator.of(context)
          .pushNamed('/add_adress')
          .then((value) => adressesCubit.getAdresses());
    });

    makeOrderAction.bind((_) => _spendPoints());

    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      await OrderFreePackagingSaver.save(
        productItemModel,
        address,
      );

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWM.userData.content(userRepository);
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
        title: 'Произошла ошибка',
        subtitle: e.toString(),
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
            model: productItemModel,
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

class OrderFreePackagingSaver {
  static Future<BaseResponseRepository> save(
    ProductItemModel model,
    AdressModel address,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.put<Map<String, dynamic>>(
      '/order/freePack/save/',
      data: FormData.fromMap(
        <String, dynamic>{
          //TODO(Nikita): написать
          'productId': model.id,
          'price': model.price,
          'addressId': address.id,
          'diopters': 0,
          'cylinder': 0,
          'axis': 0,
          'addiction': 0,
          'color': 0,
        },
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    );

    final data = resp.data!;

    return BaseResponseRepository.fromMap(data);
  }
}

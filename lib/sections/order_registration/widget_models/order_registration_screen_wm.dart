import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/models/profile_settings/lens_parameters_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/my_adresses/cubit/adresses_cubit.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
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
  final loadingLensState = StreamedState<bool>(false);

  final address = StreamedState<AdressModel?>(null);

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+0 000 000 00 00');

  final lensBloc = LensBloc();

  final diopters = StreamedState<String?>(null);
  final addidations = StreamedState<String?>(null);
  final cylinder = StreamedState<String?>(null);
  final axis = StreamedState<String?>(null);
  final color = StreamedState<String?>(null);

  late LensParametersModel? lensParametersModel;

  late bool nameFieldEnabled;
  late bool lastNameFieldEnabled;

  late UserWM userWM;

  //late AdressModel address;

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

    nameController.text = userWM.userData.value.data!.user.name ?? '';
    lastNameController.text = userWM.userData.value.data!.user.lastName ?? '';
    phoneController.text = userWM.userData.value.data!.user.phone;
    emailController.text = userWM.userData.value.data!.user.email ?? '';

    if (productItemModel.specifications != null) {
      subscribe(lensBloc.stream, (value) {
        if (productItemModel.specifications!.diopters != null) {
          if (productItemModel.specifications!.diopters!
              .contains(lensBloc.state.model.diopter.toString())) {
            diopters.accept(lensBloc.state.model.diopter.toString());
          }
        }

        if (productItemModel.specifications!.cylinder != null) {
          if (productItemModel.specifications!.cylinder!
              .contains(lensBloc.state.model.cylinder.toString())) {
            diopters.accept(lensBloc.state.model.cylinder.toString());
          }
        }

        if (productItemModel.specifications!.axis != null) {
          if (productItemModel.specifications!.axis!
              .contains(lensBloc.state.model.axis.toString())) {
            diopters.accept(lensBloc.state.model.axis.toString());
          }
        }

        if (productItemModel.specifications!.addiction != null) {
          if (productItemModel.specifications!.addiction!
              .contains(lensBloc.state.model.addict.toString())) {
            diopters.accept(lensBloc.state.model.addict.toString());
          }
        }
      });
    }

    nameFieldEnabled = userWM.userData.value.data!.user.name == null;
    lastNameFieldEnabled = userWM.userData.value.data!.user.lastName == null;

    addAddressAction.bind((_) {
      Navigator.of(context)
          .pushNamed('/add_adress')
          .then((value) => adressesCubit.getAdresses());
    });

    makeOrderAction.bind((_) => _spendPoints());

    super.onBind();
  }

  Future<void> updateUserData() async {
    if ((nameController.text != userWM.userData.value.data!.user.name) ||
        (lastNameController.text !=
            userWM.userData.value.data!.user.lastName)) {
      await userWM.updateUserData(
        userWM.userData.value.data!.user.copyWith(
          name: userWM.userData.value.data!.user.name ?? nameController.text,
          lastName: userWM.userData.value.data!.user.lastName ??
              lastNameController.text,
        ),
      );
    }
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      if ((nameController.text.isEmpty) || (lastNameController.text.isEmpty)) {
        error = const CustomException(
          title: 'Необходимо ввести имя и фамилию',
        );
        return;
      }

      await OrderFreePackagingSaver.save(
        productItemModel,
        address.value!,
        diopters: diopters.value,
        cylinder: cylinder.value,
        axis: axis.value,
        addiction: addidations.value,
        color: color.value,
      );

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWM.userData.content(userRepository);

      await updateUserData();
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
    AdressModel address, {
    String? diopters,
    String? cylinder,
    String? axis,
    String? addiction,
    String? color,
  }) async {
    final rh = RequestHandler();
    final resp = await rh.put<Map<String, dynamic>>(
      '/order/freePack/save/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          'price': model.price,
          'addressId': address.id,
          if (diopters != null) 'diopters': diopters,
          if (cylinder != null) 'cylinder': cylinder,
          if (axis != null) 'axis': axis,
          if (addiction != null) 'addiction': addiction,
          if (color != null) 'color': color,
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

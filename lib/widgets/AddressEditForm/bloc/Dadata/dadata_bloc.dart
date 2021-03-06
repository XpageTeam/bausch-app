// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:async';
import 'dart:convert';

import 'package:bausch/models/dadata/dadata_response_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

part 'dadata_event.dart';
part 'dadata_state.dart';

class DadataBloc extends Bloc<DadataEvent, DadataState> {
  // final String city;

  DadataBloc(/*{required this.city}*/) : super(DadataInitial()) {
    on<DadataChangeText>((event, emit) async {
      emit(DadataLoading());
      emit(await _sendRequest(event.text));
    });

    on<DadataSetEmptyField>((event, emit) => emit(DadataInitial()));
  }

  // yield DadataLoading();
  //     yield await _sendRequest(event.text);

  Future<DadataState> _sendRequest(String userText) async {
    try {
      final result = await http.post(
        Uri.parse(
          'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ${StaticData.dadataApiKey}',
        },
        body: json.encode(
          {
            'query': userText,
            'count': 15,
            // 'locations': [
            //   {'city': city},
            //   // {"street": userText}
            // ],
            'from_bound': {'value': 'street'},
            'to_bound': {'value': 'house'},
          },
        ),
      );

      return DadataSuccess(
        models: ((json.decode(result.body)
                as Map<String, dynamic>)['suggestions'] as List<dynamic>)
            .map((dynamic e) =>
                DadataResponseModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
    } on Exception catch (e) {
      debugPrint('запрос подсказок $e');
      return DadataFailed(
        title: 'Улица не найдена...',
        subtitle: e.toString(),
      );
    }
  }
}

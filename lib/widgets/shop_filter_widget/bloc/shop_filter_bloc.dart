import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'shop_filter_event.dart';
part 'shop_filter_state.dart';

class ShopFilterBloc extends Bloc<ShopFilterEvent, ShopFilterState> {
  final String defaultFilter;
  List<String> selectedFilters = [];
  ShopFilterBloc({
    required this.defaultFilter,
  }) : super(
          ShopFilterInitial(
            defaultFilter: defaultFilter,
          ),
        ) {
    on<ShopFilterEvent>(
      (event, emit) {
        if (event is ShopFilterClearEvent) {
          selectedFilters = [];
          _afterRemovingFilters(emit);
        }

        if (event is ShopFilterChangeEvent) {
          selectedFilters.remove(defaultFilter);

          if (!selectedFilters.remove(event.filter)) {
            selectedFilters.add(event.filter);
          }

          if (selectedFilters.isEmpty) {
            _afterRemovingFilters(emit);
          } else {
            emit(
              ShopFilterChange(
                selectedFilters: selectedFilters,
              ),
            );
          }
        }

        debugPrint('selectedFilters: $selectedFilters');
      },
    );
  }
  void _afterRemovingFilters(Emitter emit) {
    selectedFilters.add(defaultFilter);

    emit(
      ShopFilterClear(
        selectedFilters: selectedFilters,
      ),
    );
  }
}

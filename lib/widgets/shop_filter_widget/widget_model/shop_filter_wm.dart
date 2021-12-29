import 'package:bausch/models/shop/filter_model.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ShopFilterWM extends WidgetModel {
  final List<Filter> initialFilters;
  final void Function(List<Filter> selectedFilters) callback;

  late final filtersStreamed =
      StreamedState<List<Filter>>([initialFilters.first]);

  final selectFilter = StreamedAction<Filter>();
  final updateFilters = StreamedAction<List<Filter>>();

  late List<Filter> selectedFilters = <Filter>[initialFilters.first];

  ShopFilterWM({
    required this.initialFilters,
    required this.callback,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    selectFilter.bind((filter) => _selectFilter(filter!));

    updateFilters.bind(_updateFilters);

    super.onBind();
  }

  void _updateFilters(List<Filter>? filters) {
    _setOnlyDefaultFilter();
    filtersStreamed.accept(filters!);

    callback(selectedFilters);
  }

  void _selectFilter(Filter filter) {
    if (_isDefaultFilter(filter)) {
      _setOnlyDefaultFilter();
    } else {
      _removeDefaultFilter();

      if (_containsFilter(filter)) {
        _removeFilter(filter);
      } else {
        _addFilter(filter);
      }
    }

    if (selectedFilters.isEmpty) {
      _setOnlyDefaultFilter();
    }

    filtersStreamed.accept(filtersStreamed.value);
    callback(selectedFilters);
  }

  /// Проверка на фильтр "Все оптики"
  bool _isDefaultFilter(Filter? filter) => filter!.id == 0;

  /// Содержится ли фильтр в списке выбранных
  bool _containsFilter(Filter filter) =>
      selectedFilters.any((element) => element == filter);

  void _addFilter(Filter filter) {
    selectedFilters.add(
      filter,
    );
  }

  void _removeFilter(Filter filter) {
    selectedFilters.removeWhere(
      (element) => element == filter,
    );
  }

  /// Удаляет фильтр "Все оптики"
  void _removeDefaultFilter() {
    selectedFilters.removeWhere(
      (filter) => filter.id == 0,
    );
  }

  /// Включает только фильтр "Все оптики"
  List<Filter> _setOnlyDefaultFilter() =>
      selectedFilters = [filtersStreamed.value.first];
}

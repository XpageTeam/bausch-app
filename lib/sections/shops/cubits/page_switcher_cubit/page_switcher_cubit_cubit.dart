import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'page_switcher_cubit_state.dart';

class PageSwitcherCubit extends Cubit<PageSwitcherState> {
  PageSwitcherCubit() : super(PageSwitcherInitial());

  void changePage(int pageIndex) => emit(
        pageIndex == 0 ? PageSwitcherShowMap() : PageSwitcherShowList(),
      );
}

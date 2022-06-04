import 'package:asmixer/screens/events/category_visibility_event.dart';
import 'package:asmixer/screens/states/category_visibility_state.dart';
import 'package:bloc/bloc.dart';

class CategoryVisibilityBloc
    extends Bloc<CategoryVisibilityEvent, CategoryVisibilityState> {
  CategoryVisibilityBloc(CategoryVisibilityState initialState)
      : super(initialState) {
    on<CategoryVisibilityChangedEvent>(_onCategoryVisibilityChangedEvent);
  }

  _onCategoryVisibilityChangedEvent(
      CategoryVisibilityChangedEvent event, Emitter emit) {
    emit(CategoryVisibilityState(
      event.topCategory ? !state.topVisibility : state.topVisibility,
      event.topCategory ? state.mediumVisibility : !state.mediumVisibility,
    ));
  }
}

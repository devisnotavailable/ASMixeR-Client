import 'package:asmixer/screens/states/fab_state.dart';
import 'package:bloc/bloc.dart';

import '../events/fab_event.dart';

class FabBloc extends Bloc<FabEvent, FabState> {
  FabBloc(FabState initialState) : super(initialState) {
    on<ShowFabEvent>(_onFabEvent);
  }

  _onFabEvent(ShowFabEvent event, Emitter emit) {
    emit(FabState(event.showFab));
  }
}

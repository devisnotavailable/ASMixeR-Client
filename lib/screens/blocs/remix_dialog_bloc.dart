import 'package:asmixer/screens/events/remix_dialog_event.dart';
import 'package:asmixer/screens/states/remix_dialog_state.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:bloc/bloc.dart';

class RemixDialogBloc extends Bloc<RemixDialogEvent, RemixDialogState> {
  final SharedPreferencesUtils sharedPreferencesUtils;

  RemixDialogBloc(RemixDialogState initialState, this.sharedPreferencesUtils)
      : super(initialState) {
    on<RemixActionChangedEvent>(_onRemixActionChoice);
  }

  _onRemixActionChoice(RemixActionChangedEvent event, Emitter emit) {
    sharedPreferencesUtils.setRemixAction(event.remixAction);
    emit(RemixDialogState(event.remixAction));
  }
}

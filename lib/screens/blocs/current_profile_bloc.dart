import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/database/dao/profile_dao.dart';
import 'package:asmixer/screens/events/current_profile_event.dart';
import 'package:asmixer/screens/states/current_profile_state.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:bloc/bloc.dart';

class CurrentProfileBloc
    extends Bloc<CurrentProfileEvent, CurrentProfileState> {
  final SharedPreferencesUtils sharedPreferencesUtils;
  final ProfileDao profileDao;
  late Profile _initialProfile; //profile which was set before

  CurrentProfileBloc(CurrentProfileState initialState,
      {required this.sharedPreferencesUtils, required this.profileDao})
      : super(initialState) {
    on<InitialProfileEvent>(_onCurrentProfileEvent);
    on<BackFromProfilesScreenEvent>(_onBackFromProfilesScreen);
    on<SelectNewProfileEvent>(_onCurrentProfileChangedEvent);
  }

  Future<Profile?> _getCurrentProfile() async {
    return profileDao
        .getProfileByID(sharedPreferencesUtils.getSelectedProfile());
  }

  _onCurrentProfileEvent(InitialProfileEvent event, Emitter emit) async {
    var selectedProfile = await _getCurrentProfile();
    _initialProfile = selectedProfile!;
    emit(CurrentProfileState(selectedProfile: selectedProfile));
  }

  _onBackFromProfilesScreen(
      BackFromProfilesScreenEvent event, Emitter emit) async {
    var profileChanged = _initialProfile != state.selectedProfile;

    if (profileChanged) {
      _initialProfile = state.selectedProfile!;
      emit(CurrentProfileChangedState(state.selectedProfile));
    }
  }

  _onCurrentProfileChangedEvent(SelectNewProfileEvent event, Emitter emit) {
    sharedPreferencesUtils.setSelectedProfile(event.newProfile.id!);
    emit(CurrentProfileState(selectedProfile: event.newProfile));
  }
}

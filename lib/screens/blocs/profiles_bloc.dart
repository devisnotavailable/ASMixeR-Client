import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/data/entities/profile_to_category.dart';
import 'package:asmixer/database/dao/profile_dao.dart';
import 'package:asmixer/database/dao/profile_to_category_dao.dart';
import 'package:asmixer/screens/events/profiles_event.dart';
import 'package:asmixer/screens/states/profiles_state.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfileDao profileDao;
  ProfileToCategoryDao profileToCategoryDao;
  SharedPreferencesUtils sharedPreferencesUtils;

  ProfilesBloc(ProfilesState initialState,
      {required this.profileDao,
      required this.sharedPreferencesUtils,
      required this.profileToCategoryDao})
      : super(initialState) {
    on<LoadProfilesEvent>(
      _onLoadProfilesEvent,
      transformer: droppable(),
    );
    on<RemoveProfileEvent>(_onRemoveProfileEvent);
    on<UndoRemoveProfile>(_onUndoRemoveProfileEvent);
    on<EditProfileModeEvent>(_onEditProfileMode);
  }

  _onLoadProfilesEvent(LoadProfilesEvent event, Emitter emit) async {
    await emit.onEach(profileDao.getProfilesStream(),
        onData: (List<Profile> profileList) {
      emit(ProfilesState(profilesList: profileList));
    });
  }

  _onRemoveProfileEvent(RemoveProfileEvent event, Emitter emit) {
    List<Profile> newProfiles = List.of(state.profilesList);
    newProfiles.remove(event.profile);
    profileDao.deleteEntity(event.profile);
    emit(ProfileRemovedState(
        newProfiles, state.editActiveID, event.profile, event.categoryList));
  }

  _onUndoRemoveProfileEvent(UndoRemoveProfile event, Emitter emit) async {
    await profileDao.insertEntity(event.profile);
    for (var category in event.categoryList) {
      await profileToCategoryDao.insertEntity(ProfileToCategory(
          profileID: event.profile.id!, categoryID: category.id));
    }
  }

  _onEditProfileMode(EditProfileModeEvent event, Emitter emit) {
    emit(ProfilesState(
        profilesList: state.profilesList, editActiveID: event.profileToEditID));
  }
}

import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/profile.dart';

abstract class ProfilesEvent {}

class LoadProfilesEvent extends ProfilesEvent {}

class AddProfileEvent extends ProfilesEvent {
  final Profile profile;

  AddProfileEvent(this.profile);
}

class RemoveProfileEvent extends ProfilesEvent {
  final Profile profile;
  final List<Category> categoryList;

  RemoveProfileEvent(this.profile, this.categoryList);
}

class UndoRemoveProfile extends ProfilesEvent {
  final Profile profile;
  final List<Category> categoryList;

  UndoRemoveProfile(this.profile, this.categoryList);
}

class EditProfileModeEvent extends ProfilesEvent {
  final int profileToEditID;

  EditProfileModeEvent(this.profileToEditID);
}

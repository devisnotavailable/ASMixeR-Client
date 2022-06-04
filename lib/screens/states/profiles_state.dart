import 'package:asmixer/data/entities/profile.dart';

import '../../data/entities/category.dart';

class ProfilesState {
  final List<Profile> profilesList;
  final int editActiveID;

  ProfilesState({this.profilesList = const [], this.editActiveID = -1});
}

class ProfileRemovedState extends ProfilesState {
  final Profile removedProfile;
  final List<Category> removedCategories;

  ProfileRemovedState(List<Profile> profileList, int editActiveID,
      this.removedProfile, this.removedCategories)
      : super(profilesList: profileList, editActiveID: editActiveID);
}

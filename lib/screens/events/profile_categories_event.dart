import '../../data/entities/profile_to_category.dart';

abstract class ProfileCategoriesEvent {}

class LoadCategoriesEvent extends ProfileCategoriesEvent {
  final int profileID;

  LoadCategoriesEvent(this.profileID);
}

class ProfileToCategoriesReadyEvent extends ProfileCategoriesEvent {
  final List<ProfileToCategory> profileToCategoryList;

  ProfileToCategoriesReadyEvent(this.profileToCategoryList);
}

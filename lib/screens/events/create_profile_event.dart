import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/profile.dart';

class CreateProfileEvent {}

class InitCreateProfileEvent extends CreateProfileEvent {}

class SelectedCategoryChangedEvent extends CreateProfileEvent {
  final Category category;

  SelectedCategoryChangedEvent(this.category);
}

class InitCategoryEvent extends CreateProfileEvent {
  final Profile? profile;

  InitCategoryEvent(this.profile);
}

class SaveProfileEvent extends CreateProfileEvent {
  final String name;

  SaveProfileEvent(this.name);
}

class ChangeProfileEvent extends CreateProfileEvent {
  final Profile profile;

  ChangeProfileEvent(this.profile);
}

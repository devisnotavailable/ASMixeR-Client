import 'package:asmixer/data/entities/profile.dart';

class CurrentProfileEvent {}

class InitialProfileEvent extends CurrentProfileEvent {}

class BackFromProfilesScreenEvent extends CurrentProfileEvent {}

class SelectNewProfileEvent extends CurrentProfileEvent {
  final Profile newProfile;

  SelectNewProfileEvent(this.newProfile);
}

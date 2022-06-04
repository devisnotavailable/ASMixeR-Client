import 'package:asmixer/data/entities/profile.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CurrentProfileState {
  final Profile? selectedProfile;

  const CurrentProfileState({this.selectedProfile});
}

class CurrentProfileChangedState extends CurrentProfileState {
  const CurrentProfileChangedState(selectedProfile)
      : super(selectedProfile: selectedProfile);
}

import 'package:flutter/cupertino.dart';

import 'base_state.dart';

@immutable
class NavigationState extends BaseState {
  final int selectedIndex;
  final List<Widget> screens;

  @override
  List<Object> get props => [selectedIndex];

  NavigationState(this.selectedIndex, this.screens);
}

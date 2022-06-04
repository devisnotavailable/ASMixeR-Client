import 'package:flutter/material.dart';

enum InitState { INIT, WORKING, COMPLETED }

@immutable
class InitBlocState {
  final InitState initState;

  const InitBlocState({this.initState = InitState.INIT});
}

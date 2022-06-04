import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class BaseState extends Equatable {
  @override
  List<Object> get props => [];
}

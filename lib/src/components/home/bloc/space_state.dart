part of 'space_bloc.dart';

@immutable
abstract class SpaceState {}

class SpaceInitial extends SpaceState {}

class NoSpace extends SpaceState {}

class HasSpace extends SpaceState {}

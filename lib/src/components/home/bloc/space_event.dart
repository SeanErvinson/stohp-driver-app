part of 'space_bloc.dart';

@immutable
abstract class SpaceEvent {}

class SpaceFull extends SpaceEvent {}

class SpaceHas extends SpaceEvent {}

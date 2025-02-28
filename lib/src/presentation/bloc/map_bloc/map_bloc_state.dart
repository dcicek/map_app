part of 'map_bloc_bloc.dart';

abstract class MapState {
  final List<LatLng> positionList;
  MapState({required this.positionList});
  List<Object> get props => [positionList];
}

class MapInitial extends MapState {
  final LatLng position;
  MapInitial({required this.position, required super.positionList});

  @override
  List<Object> get props => [position];
}

class MapLoading extends MapState {
  MapLoading({required super.positionList});
}

class MapLoaded extends MapState {
  final LatLng position;
  MapLoaded({required this.position, required super.positionList});

  @override
  List<Object> get props => [position, positionList];
}

class MapFailed extends MapState {
  final String error;
  MapFailed({required this.error, required super.positionList});

  @override
  List<Object> get props => [error];
}

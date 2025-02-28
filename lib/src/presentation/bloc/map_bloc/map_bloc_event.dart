part of 'map_bloc_bloc.dart';

abstract class MapEvent {}

class UpdateMap extends MapEvent {
  UpdateMap();
}

class GetLocation extends MapEvent {
  GetLocation();
}

class GetLocationOnDevice extends MapEvent {
  GetLocationOnDevice();
}

class ListenLocation extends MapEvent {
  ListenLocation();
}

class StopListening extends MapEvent {
  StopListening();
}

class Emitter extends MapEvent {
  final List<LatLng> positionList;
  Emitter({required this.positionList});
}

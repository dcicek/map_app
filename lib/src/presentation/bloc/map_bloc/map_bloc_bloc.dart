import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/src/data/datasources/service/shared_pref.dart';
import 'package:map_app/src/data/repositories/map_repo.dart';

part 'map_bloc_state.dart';
part 'map_bloc_event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapRepo repo;
  MapBloc(this.repo)
      : super(MapInitial(
            position: const LatLng(0.0, 0.0),
            positionList: [const LatLng(0.0, 0.0)])) {
    on<GetLocation>((event, emit) async {
      try {
        emit(MapLoading(positionList: state.positionList));
        LatLng? position = await repo.getCurrentLocation();
        emit(MapLoaded(
            position: position ?? const LatLng(0.0, 0.0),
            positionList: [position!]));
      } catch (e) {
        log(e.toString());
      }
    });

    on<GetLocationOnDevice>((event, emit) async {
      try {
        emit(MapLoading(positionList: state.positionList));
        List<LatLng> position = repo.getLocationList();

        if (position.isNotEmpty) {
          emit(MapLoaded(
              position: const LatLng(0.0, 0.0),
              positionList:
                  position.isEmpty ? [const LatLng(0.0, 0.0)] : position));
        } else {
          add(GetLocation());
        }
      } catch (e) {
        log(e.toString());
        emit(MapFailed(error: e.toString(), positionList: state.positionList));
      }
    });

    on<ListenLocation>((event, emit) async {
      try {
        List<LatLng> positions = List.from(state.positionList);
        List<String> positionList = [];
        for (var item in positions) {
          positionList.add("${item.latitude},${item.longitude}");
        }
        repo.listenLocation((LatLng newLocation) {
          positions.add(newLocation);
          positionList.add("${newLocation.latitude},${newLocation.longitude}");
          SharedPreferencesHelper.setPositions(positionList);
          add(Emitter(positionList: positions));
        });
      } catch (e) {
        log(e.toString());
      }
    });

    on<StopListening>((event, emit) {
      repo.stopListening();
    });

    on<Emitter>((event, emit) {
      emit(MapLoaded(
          position: const LatLng(0.0, 0.0), positionList: event.positionList));
    });
  }
}

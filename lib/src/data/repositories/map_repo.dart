import 'package:latlong2/latlong.dart';
import 'package:map_app/src/data/datasources/service/geolocator_service.dart';

class MapRepo {
  GeoLocatorService service;
  MapRepo({required this.service});

  Future<LatLng?> getCurrentLocation() async {
    return await service.getCurrentLocation();
  }

  List<LatLng> getLocationList() {
    return service.getlocationList();
  }

  void listenLocation(Function(LatLng newLocation) returnLocation) {
    service.listenLocation(returnLocation);
  }

  void stopListening() {
    service.stopListening();
  }
}

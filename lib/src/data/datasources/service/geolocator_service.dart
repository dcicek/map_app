import 'dart:async';
import 'dart:developer';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/src/data/datasources/service/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeoLocatorService {
  static final GeoLocatorService _instance = GeoLocatorService._internal();
  factory GeoLocatorService() => _instance;
  GeoLocatorService._internal();

  final StreamController<List<LatLng>> _locationController =
      StreamController.broadcast();
  Stream<List<LatLng>> get locationStream => _locationController.stream;

  StreamSubscription<Position>? _positionSubscription;
  List<LatLng> _locations = [];

  Future<LatLng?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    log(position.toString());
    return LatLng(position.latitude, position.longitude);
  }

  List<LatLng> getlocationList() {
    List<String> positions = SharedPreferencesHelper.getPositions();
    List<LatLng> latLng = [];
    for (var item in positions) {
      List latLngList = item.split(",");
      latLng.add(LatLng(
          double.parse(latLngList.first), double.parse(latLngList.last)));
    }
    return latLng;
  }

  Future<void> listenLocation(
      Function(LatLng newLocation) returnLocation) async {
    BackgroundGeolocation.onLocation((Location location) {
      LatLng newLocation =
          LatLng(location.coords.latitude, location.coords.longitude);
      returnLocation(newLocation);
    });

    BackgroundGeolocation.ready(Config(
      desiredAccuracy: Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 100,
      stopOnTerminate: false,
      startOnBoot: true,
    )).then((_) {
      BackgroundGeolocation.start();
    });
  }

  void stopListening() {
    _positionSubscription?.cancel();
  }

  Future<void> clearRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('locations');
    _locations.clear();
    _locationController.add([]);
  }

  Future<void> loadSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('locations');

    if (savedLocations != null) {
      _locations = savedLocations.map((loc) {
        var latLng = loc.split(',');
        return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
      }).toList();
      _locationController.add(List.from(_locations));
    }
  }

  void dispose() {
    _positionSubscription?.cancel();
    _locationController.close();
  }
}

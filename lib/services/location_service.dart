import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<Position>? _positionStream;

  void dispose() {
    if (_positionStream != null) {
      _positionStream!.cancel();
      _positionStream = null;
    }
  }

  Future<bool?> get checkLocationServiceEnabled async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> get checkLocationPermission async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("nooo now");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("noo forever");
    }
  }

  Future<void> locationPositionStream(
      Function(Position position) onGettingPosition) async {
    if (await checkLocationServiceEnabled != true) {
      return;
    }
    _positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      if (position != null) {
        onGettingPosition(position);
      }
    });
  }
}

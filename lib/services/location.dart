import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Location {
  LatLng coordinate;

  Future<LatLng> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      coordinate = LatLng(position.longitude, position.latitude);

      return coordinate;
    } catch (e) {
      print(e);
    }
  }
}

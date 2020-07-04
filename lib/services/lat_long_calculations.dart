import 'dart:math' show cos, sqrt, asin;
import 'package:mapbox_gl/mapbox_gl.dart';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

double calculate_list_lat_long(List<LatLng> list) {
  double totalDistance = 0;
  for (var i = 0; i < list.length - 1; i++) {
    totalDistance += calculateDistance(list[i].latitude, list[i].longitude,
        list[i + 1].latitude, list[i + 1].longitude);
  }
  print('total distance $totalDistance');
  return totalDistance;
}

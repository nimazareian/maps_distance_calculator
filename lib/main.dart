import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'api_key.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController = MapController();

  var points = <LatLng>[
    LatLng(35.22, -101.83),
    LatLng(32.77, -96.79),
    LatLng(29.76, -95.36),
    LatLng(29.42, -98.49),
    LatLng(35.22, -101.83),
  ];

//   _onMapTapped(LatLng point) {
//     CustomPoint<num> screenPosition = Epsg3857().latLngToPoint(mapController.center, mapController.zoom);
//     print('Map Center: ${mapController.center}, zoom: ${mapController.zoom}');
//     print('Screen position: $screenPosition');
// }
  // CustomPoint<num> northWestPoint =
  //     Epsg3857().latLngToPoint(mapPosition.bounds.northWest, mapPosition.zoom);
  // CustomPoint<num> markerPoint =
  //     Epsg3857().latLngToPoint(markerLatLng, mapPosition.zoom);
  // double x = markerPoint.x - northWestPoint.x;
  // double y = markerPoint.y - northWestPoint.y;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaflet Maps')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(49.2827, -123.1207),
          minZoom: 5.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: TEMPLATE_URL,
            additionalOptions: {
              'accessToken': API_KEY,
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          PolylineLayerOptions(
            polylines: [
              Polyline(points: points, strokeWidth: 5.0, color: Colors.red)
            ],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(49.2827, -123.1207),
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ],
        mapController: MapController(),
      ),
    );
  }
}

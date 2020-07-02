import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'api_key.dart';

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
  var points = <LatLng>[
    LatLng(35.22, -101.83),
    LatLng(32.77, -96.79),
    LatLng(29.76, -95.36),
    LatLng(29.42, -98.49),
    LatLng(35.22, -101.83),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaflet Maps')),
      body: FlutterMap(
        options: MapOptions(center: LatLng(49.2827, 123.1207), minZoom: 5.0),
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
                point: new LatLng(51.5, -0.09),
                builder: (ctx) => Container(
                  child: new FlutterLogo(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

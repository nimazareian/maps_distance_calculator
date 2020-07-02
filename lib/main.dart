import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'api_key.dart'
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var points = <LatLng>[
        new LatLng(35.22, -101.83),
        new LatLng(32.77, -96.79),
        new LatLng(29.76, -95.36),
        new LatLng(29.42, -98.49),
        new LatLng(35.22, -101.83),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Leaflet Maps')),
        body: new FlutterMap(
            options: new MapOptions(
                center: new LatLng(35.22, -101.83), minZoom: 5.0),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                      TEMPLATE_URL,
                  additionalOptions: {
                    'accessToken':
                        API_KEY,
                    'id': 'mapbox.mapbox-streets-v8'
                  }),
              new PolylineLayerOptions(
                polylines: [
                  new Polyline(
                    points: points,
                    strokeWidth: 5.0,
                    color: Colors.red
                  )
                ]
              )
            ]));
  }
}
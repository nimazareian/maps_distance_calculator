import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_distance_calculator/services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_distance_calculator/services/lat_long_calculations.dart';

const _styling = 'mapbox://styles/nimnim10543/ckc6xzcdo1qbo1inse564aqu3';

class MapScreen extends StatefulWidget {
  MapScreen({this.userLocation});

  final userLocation;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  LatLng userLocation;
  List<LatLng> lines = List<LatLng>();
  double totalDistance = 0;

  @override
  void initState() {
    super.initState();
    updateUI(widget.userLocation);
    print('test test ${userLocation.toString()}'); //todo test
  }

  @override
  void dispose() {
    // mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  void updateUI(dynamic startLocation) {
    if (startLocation != null) {
      userLocation = startLocation;
    }
    print('user location is: $userLocation');
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 20.211), //what is this target?
    zoom: 11.0,
  );

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void getCameraCoordinate() {
    setState(() {
      _position = mapController.cameraPosition; //doesn't update, stays at init
    });
    print('FAB clicked, position: $_position');
  }

  void _add() {
    getCameraCoordinate();
    totalDistance = calculate_list_lat_long(lines);
    setState(() {
      lines.add(_position.target);

      mapController.addLine(
        LineOptions(
          geometry: lines,
          draggable: false,
          lineColor: '#000000',
          lineWidth: 8.0,
          lineJoin: 'round',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Calculator'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          MapboxMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(49.329051, -123.141076), //userLocation
              zoom: 12,
            ),
            styleString: _styling,
            trackCameraPosition:
                true, //OOOOOOOOOOMMMMMMGGGGGGGGGGGGGGGGGGGGGGGGGGGG
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 40,
            ),
            child: Icon(
              Icons.location_on,
              size: 50,
              color: Colors.redAccent,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              // 'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
              // '${_position.target.longitude.toStringAsFixed(4)}'
              totalDistance.toStringAsFixed(3) + ' miles?',
              style: TextStyle(
                fontSize: 45,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(32.0),
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: _add, //getCameraCoordinate,
              child: Icon(Icons.add),
            ),
          ),
          Container(
            padding: EdgeInsets.all(32.0),
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: _add, //getCameraCoordinate,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

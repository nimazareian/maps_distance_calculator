import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_distance_calculator/services/location.dart';

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
    // mapController.addListener(_onMapChanged);
    // _onMapChanged();
  }

  // void _onMapChanged() {
  //   setState(() {
  //     _position = mapController.cameraPosition;
  //   });
  // }

  void getCameraCoordinate() {
    setState(() {
      _position = mapController.cameraPosition; //doesn't update, stays at init
    });
    print('FAB clicked, position: $_position');
  }

  void _add() {
    getCameraCoordinate();

    // print('position: ${_position.target}');

    // if (_position.target != null) {
    //   print('AMMMMM NO NULL!!!!!!');
    //   lines.add(_position.target);
    // } else {
    //   print('wooooAAAAH NULLL');
    // }

    // print('lines: ${lines.toString()}');
    setState(() {
      mapController.addLine(
        LineOptions(
          geometry: lines,
          // [
          //   LatLng(49.329051, -123.141076),
          //   LatLng(49.329051, -124.141076),
          //   LatLng(50.329051, -123.141076),
          //   LatLng(49.329051, -123.141076),
          // ],
          draggable: false,
          lineColor: '#000000',
          lineWidth: 10.0,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _add, //getCameraCoordinate,
        child: Icon(Icons.add),
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
          Icon(
            Icons.location_on,
            size: 50,
            color: Colors.redAccent,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
                'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                '${_position.target.longitude.toStringAsFixed(4)}'),
          )
        ],
      ),
    );
  }
}

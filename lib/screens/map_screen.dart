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
  Line _selectedLine;
  CameraPosition _position = _kInitialPosition;
  LatLng userLocation;
  List<LatLng> lines = List<LatLng>();
  double totalDistance = 0;
  int _circleCount = 0;
  Circle _selectedCircle;

  @override
  void initState() {
    super.initState();
    updateUI(widget.userLocation);
    // print('test test ${userLocation.toString()}'); //todo test
  }

  @override
  void dispose() {
    // mapController.removeListener(_onMapChanged);
    mapController?.onLineTapped?.remove(_onLineTapped); ////////////////
    super.dispose();
  }

  void updateUI(dynamic startLocation) {
    if (startLocation != null) {
      userLocation = startLocation;
    }
    // print('user location is: $userLocation');
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 20.211), //what is this target?
    zoom: 11.0,
  );

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    controller.onLineTapped
        .add(_onLineTapped); ////////////////////////////////////
    mapController.onCircleTapped.add(_onCircleTapped);
  }

  void getCameraCoordinate() {
    setState(() {
      _position = mapController.cameraPosition; //doesn't update, stays at init
    });
  }

  void _removeCircle() {
    mapController.removeCircle(_selectedCircle);
    removePointLine(_selectedCircle.options.geometry);
    setState(() {
      _selectedCircle = null;
      _circleCount -= 1;
      totalDistance = calculate_list_lat_long(lines);
    });
  }

  void removePointLine(LatLng circleCoord) {
    for (LatLng lineCoord in lines) {
      if (circleCoord == lineCoord) {
        lines.remove(circleCoord);
        drawLines();
        return;
      }
    }
  }

  void _onCircleTapped(Circle circle) {
    if (_selectedCircle != null) {
      _updateSelectedCircle(
        CircleOptions(
          circleRadius: 4.5,
          circleColor: "#ff3300",
        ),
      );
    }
    setState(() {
      if (_selectedCircle == circle) {
        _selectedCircle = null;
      } else {
        _selectedCircle = circle;
      }
    });
    _updateSelectedCircle(
      CircleOptions(
        circleRadius: 8,
        circleColor: "#ffffff",
      ),
    );
  }

  void _updateSelectedCircle(CircleOptions changes) {
    mapController.updateCircle(_selectedCircle, changes);
  }

  void _add() {
    getCameraCoordinate();
    // mapController.clearLines();
    setState(() {
      lines.add(_position.target);
      totalDistance = calculate_list_lat_long(lines);
    });
    drawLines();
    drawCircles();
  }

  void drawLines() {
    mapController.clearLines();
    mapController.addLine(
      LineOptions(
        geometry: lines,
        draggable: true,
        lineColor: '#3366ff',
        lineWidth: 5.0,
        lineJoin: 'round',
        lineOpacity: 0.40,
      ),
    );
  }

  void drawCircles() {
    mapController.addCircle(
      CircleOptions(
        geometry: _position.target,
        draggable: false,
        circleColor: "#ff3300",
        circleRadius: 6, //4.5
        circleStrokeWidth: 1.5,
        circleStrokeColor: "#000000",
      ),
    );
    _circleCount += 1;
  }

  void _onLineTapped(Line line) {
    if (_selectedLine != null) {
      _updateSelectedLine(
        const LineOptions(
          lineWidth: 28.0,
        ),
      );
    }
    setState(() {
      _selectedLine = line;
    });
    _updateSelectedLine(
      LineOptions(
        lineWidth: 50,
      ),
    );
  }

// /* SELECT AND REMOVE LINE
  void _updateSelectedLine(LineOptions changes) {
    mapController.updateLine(_selectedLine, changes);
  }

  void _removeLines() {
    mapController.removeLine(_selectedLine);
    lines = [];
    setState(() {
      _selectedLine = null;
    });
  }

// */
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
            // onStyleLoadedCallback:
            //     onStyleLoadedCallback, ////////////////////////////////////////
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
              onPressed: (_selectedCircle == null)
                  ? null
                  : _removeCircle, //getCameraCoordinate,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

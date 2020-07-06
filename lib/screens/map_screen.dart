// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:maps_distance_calculator/services/location.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:maps_distance_calculator/services/lat_long_calculations.dart';
import 'package:maps_distance_calculator/components/custom_fab.dart';
import 'package:maps_distance_calculator/components/total_distance_calculator.dart';

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
  Circle _selectedCircle;

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 20.211),
    zoom: 11.0,
  );

  @override
  void initState() {
    super.initState();
    updateUI(widget.userLocation);
  }

  @override
  void dispose() {
    mapController?.onLineTapped?.remove(_onLineTapped);
    super.dispose();
  }

  void updateUI(dynamic startLocation) {
    if (startLocation != null) {
      userLocation = startLocation;
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    controller.onLineTapped.add(_onLineTapped);
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
  }

  void _onLineTapped(Line line) {
    if (_selectedLine != null) {
      _updateSelectedLine(
        const LineOptions(
          lineWidth: 10.0,
        ),
      );
    }
    setState(() {
      _selectedLine = line;
    });
    _updateSelectedLine(
      LineOptions(
        lineWidth: 10,
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Distance Calculator'),
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              MapboxMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(49.329051, -123.141076), //userLocation
                  zoom: 13,
                ),
                styleString: MapboxStyles.MAPBOX_STREETS, //_styling,
                trackCameraPosition: true,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.Tracking,
                myLocationRenderMode: MyLocationRenderMode.COMPASS,
                // onMapLongClick: (point, latLng) async {
                //   print(
                //       "Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
                // },
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
              CustomFAB(
                alignment: Alignment.topLeft,
                onTap: () {},
                icon: Icon(Icons.gps_fixed),
                heroTag: "btn3",
              ),
              Row(
                children: <Widget>[
                  CustomFAB(
                    alignment: Alignment.bottomLeft,
                    onTap: (_selectedCircle == null) ? null : _removeCircle,
                    icon: Icon(Icons.location_off),
                    heroTag: "btn2",
                  ),
                  TotalDistanceContainer(
                    text: totalDistance.toStringAsFixed(2) + ' km',
                  ),
                  CustomFAB(
                    alignment: Alignment.bottomRight,
                    onTap: _add,
                    icon: Icon(Icons.edit_location),
                    heroTag: "btn1",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

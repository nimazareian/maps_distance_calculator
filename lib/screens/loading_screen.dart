import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    Location location = Location();
    var userLocation = await location.getCurrentLocation();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MapScreen(
            userLocation: userLocation,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF81c784),
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

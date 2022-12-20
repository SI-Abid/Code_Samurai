import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  late Position coords;
  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((value) => setState(() {
          coords = value;
        })
    );
  }
  @override
  Widget build(BuildContext context) {
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(coords.latitude, coords.longitude),
      zoom: 14.4746,
    );
    return GoogleMap(initialCameraPosition: initialCameraPosition,
    markers: {
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(coords.latitude, coords.longitude),
      ),
    },
    );
  }
}
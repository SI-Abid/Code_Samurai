import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  LatLng _initialcameraposition = const LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((value) => setState(() {
          _initialcameraposition = LatLng(value.latitude, value.longitude);
        })
    );
  }
  @override
  Widget build(BuildContext context) {
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(_initialcameraposition.latitude, _initialcameraposition.longitude),
      zoom: 14.4746,
    );
    return GoogleMap(initialCameraPosition: initialCameraPosition,
    markers: {
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(_initialcameraposition.latitude, _initialcameraposition.longitude),
      ),
    },
    );
  }
}
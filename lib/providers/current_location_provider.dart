
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final currentLocationProvider = ChangeNotifierProvider((ref) => CurrentLocationProvider());

class CurrentLocationProvider extends ChangeNotifier {
  LocationData? _currentLocation;
  LocationData? get currentLocation => _currentLocation;

  Future<void> getCurrentLocation() async {
    final location = Location();
    try {
      _currentLocation = await location.getLocation();
      notifyListeners();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Permission denied');
      }
      _currentLocation = null;
    }
  }
}
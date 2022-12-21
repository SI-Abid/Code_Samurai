import 'package:code_samurai/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  Future<List<Marker>> getMarkers() async {
    final projectList = await Helper.getProjectsList();
    final markers = <Marker>[];
    for (var project in projectList) {
      markers.add(
        Marker(
          markerId: MarkerId(project.name),
          position: LatLng(project.latitude, project.longitude),
          infoWindow: InfoWindow(
            title: project.name,
            snippet: '${project.completion.toString()}% completed',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(project.name),
                    ),
                    body: Center(
                      child: Text(project.location),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Marker>>(
      future: getMarkers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: snapshot.data![0].position,
              zoom: 14.4746,
            ),
            markers: Set<Marker>.from(snapshot.data!),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
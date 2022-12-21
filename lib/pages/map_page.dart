import 'package:code_samurai/models/project.dart';
import 'package:code_samurai/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/current_location_provider.dart';

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetails(project: project)));
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
          return Consumer(builder: (context, ref, child) {
            final currentLocation = ref.watch(currentLocationProvider).currentLocation;
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
                zoom: 14.4746,
              ),
              markers: Set.from(snapshot.data!),
            );
          });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Center(
        child: Text(project.goal),
      ),
    );
  }
}
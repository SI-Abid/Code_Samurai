import 'package:code_samurai/models/project.dart';
import 'package:code_samurai/pages/project_info.dart';
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
              // stack map page on top of project info page
              showModalBottomSheet(context: context, builder: (context) {
                return ProjectInfo(project: project);
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
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
          return Consumer(builder: (_, ref, __) {
            final currentLocation =
                ref.watch(currentLocationProvider).currentLocation;
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLocation.latitude ?? 0,
                    currentLocation.longitude ?? 0),
                zoom: 16,
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

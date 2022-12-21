import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project.dart';

class Helper {
  static String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
  // get list of projects from json
  static Future<List<Project>> getProjectsList() async{
    List<Project> projects = [];
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('projects').get();
    for (var doc in snapshot.docs) {
      projects.add(Project.fromJson(doc.data()));
    }
    return projects;
  }
}
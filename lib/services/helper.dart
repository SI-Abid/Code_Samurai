import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project.dart';

class Helper {
  static String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // get list of projects from json
  static Future<List<Project>> getProjectsList() async {
    List<Project> projects = [];
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('projects').get();
    for (var doc in snapshot.docs) {
      projects.add(Project.fromJson(doc.data()));
    }
    return projects;
  }

  // add project feedback to firestore
  static Future<void> addFeedback(String projectId, String feedback) async {
    final firestore = FirebaseFirestore.instance;
    // reviews collection contains arrays of feedbacks for each project
    final docref = firestore.collection('reviews').doc(projectId);
    final doc = await docref.get();
    if (doc.exists) {
      // if doc exists, update the array
      docref.update({
        'feedbacks': FieldValue.arrayUnion([feedback])
      });
    } else {
      // if doc doesn't exist, create it
      docref.set({
        'feedbacks': [feedback]
      });
    }
  }
}

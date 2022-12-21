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
  static Future<void> addFeedback(
      String projectId, String feedback, double rating) async {
    final firestore = FirebaseFirestore.instance;
    // reviews collection contains arrays of feedbacks for each project
    // var numberOfFeedbacks;
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
    // numberOfFeedbacks = doc.get('feedbacks').length;
    final projectRef = firestore.collection('projects').doc(projectId);
    final projectDoc = await projectRef.get();
    if (projectDoc.exists) {
      // if project doc exists, update the feedback count
      // if rating field is null, set it to 0
      if (projectDoc.get('rating') == null) {
        projectRef.update({
          'rating': 0,
        });
      }
      projectRef.update({
        'rating': ((projectDoc.get('rating') + rating) / 2),
      });
    }
  }

  static Future<void> updateRating(Project project, double r) async {
    final firestore = FirebaseFirestore.instance;
    final projectRef = firestore.collection('projects').doc(project.projectId);
    final projectDoc = await projectRef.get();
    if (projectDoc.exists) {
      // if project doc exists, update the feedback count
      // if rating field doesn't exist, set it to 0
      double rating = 0;
      try {
        rating = projectDoc.get('rating');
      } catch (e) {
        // print(e);
      }
      projectRef.set({
        'rating': rating==0?r:(rating + r) / 2,
      });
      project.rating = rating==0?r:(rating + r) / 2;
    }
  }
}

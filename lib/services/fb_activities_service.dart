import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:t_helper/models/models.dart';

class FBActivitiesService extends ChangeNotifier {
  CollectionReference activitiesReference =
      FirebaseFirestore.instance.collection('activities');

  bool isLoading = false;
  String? error;
  List<Activity>? activities;
  Activity? selectedActivity;

  Future<List<Activity>?> getActivities() async {
    try {
      isLoading = true;
      notifyListeners();
      final querySnapshot = await activitiesReference.get();

      activities = [];

      for (var doc in querySnapshot.docs) {
        activities!.add(Activity.fromMap(doc.data() as Map, doc.id));
      }

      error = null;
      isLoading = false;
      notifyListeners();
      return activities;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      error = 'There was an error getting the activites list';
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/activities_controller.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/models/models.dart';

class ActivitiesService {
  CollectionReference activitiesReference =
      FirebaseFirestore.instance.collection('activities');
  ActivitiesController activitiesController = Get.find();

  Future<List<Activity>?> getActivities() async {
    try {
      activitiesController.isLoading.value = true;
      final querySnapshot = await activitiesReference.get();

      activitiesController.activities = [];

      for (var doc in querySnapshot.docs) {
        activitiesController.activities!
            .add(Activity.fromMap(doc.data() as Map, doc.id));
      }

      activitiesController.isLoading.value = false;
      return activitiesController.activities;
    } catch (e) {
      activitiesController.isLoading.value = false;
      Snackbar.error(
          'Unknown error', 'There was an error getting the activites list');
      return null;
    }
  }
}

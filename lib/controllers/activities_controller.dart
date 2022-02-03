import 'package:get/get.dart';
import 'package:t_helper/models/activity.dart';
import 'package:t_helper/services/activities_service.dart';

class ActivitiesController extends GetxController {
  var isLoading = false.obs;
  List<Activity>? activities;
  Activity? selectedActivity;

  Future<List<Activity>?> getActivities() async {
    final response = await ActivitiesService().getActivities();
    return response;
  }
}

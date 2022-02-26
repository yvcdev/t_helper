import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/screens/personal_info_setup_screen.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/widgets/home_wrapper.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User> getUser(String uid, String email, {bool navigate = true}) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        if (navigate) {
          LoginFormController form = Get.find();
          Get.offAll(() => const PersonalInfoSetupScreen());
          form.isLoading.value = false;
        }

        return User(email: email, uid: uid);
      } else {
        if (navigate) {
          LoginFormController form = Get.find();
          Get.offAll(() => const HomeWrapper());
          form.isLoading.value = false;
        }
        return User.fromSnapshot(snapshot, uid);
      }
    });
  }

  Future<User?> populateUser(String uid) async {
    final result = await _firestore.collection('users').doc(uid).get();

    if (result.exists) {
      return User.fromSnapshot(result, result.id);
    }
  }

  static Future createUserInfo(User user) async {
    PersonalInfoFormController personalInfoForm = Get.find();
    _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.detailsToMap())
        .then((value) {
      Get.offAll(() => const HomeWrapper());
      personalInfoForm.reset();
    }).catchError((e) {
      Snackbar.error('User information not created',
          'There was an error adding the information');
    });
  }

  static Future addStudentToGroup(String studentId, String groupId) async {
    try {
      await _firestore.collection('users').doc(studentId).set({
        'groups': [groupId]
      });
    } catch (e) {
      Snackbar.error(
          'Student not added', 'There was an error adding the student');
    }
  }

  Future updateUserInfo(User user, Map<String, dynamic> updateInfo) async {
    try {
      String? downloadUrl;

      if (updateInfo['profilePic'] != null) {
        if (user.profilePic != null) {
          await StorageUserService.deleteProfilePicture(user.profilePic!);
        }

        if (updateInfo['profilePic'] == '') {
          updateInfo['profilePic'] = null;
        } else {
          downloadUrl = await StorageUserService.uploadProfilePicture(
              updateInfo['profilePic'], user.uid);

          if (downloadUrl == null) return;

          updateInfo['profilePic'] = downloadUrl;
        }
      }

      await _firestore.collection('users').doc(user.uid).update(updateInfo);

      if (!Get.isRegistered<GroupUsersController>()) {
        Get.lazyPut(() => GroupUsersController());
      }

      final newUser = User(
        email: user.email,
        uid: user.uid,
        firstName: updateInfo['firstName'] ?? user.firstName,
        middleName: updateInfo.containsKey('middleName')
            ? updateInfo['middleName']
            : user.middleName,
        lastName: updateInfo['lastName'] ?? user.lastName,
      );

      if (updateInfo.containsKey('profilePic')) {
        if (updateInfo['profilePic'] == null) {
          newUser.profilePic = null;
        } else {
          newUser.profilePic = downloadUrl;
        }
      } else {
        newUser.profilePic = user.profilePic;
      }

      if (!updateInfo.containsKey('email')) {
        Snackbar.success(
            'Data update', 'The details were successfully updated');
      }
    } catch (e) {
      if (!updateInfo.containsKey('email')) {
        Snackbar.error(
            'Data update', 'There was an error updating the details');
      }
    }
  }
}

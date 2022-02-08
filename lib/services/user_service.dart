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

  Stream<User> getUser(String uid, String email) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (uid == '') return User(email: '', uid: '');
      if (!snapshot.exists) {
        Get.to(() => const PersonalInfoSetupScreen());
        return User(email: email, uid: uid);
      } else {
        return User.fromSnapshot(snapshot, uid);
      }
    });
  }

  Future<User> getUserMAnually(String uid) async {
    final _user = await _firestore.collection('users').doc(uid).get();

    if (_user.exists) {
      return User.fromSnapshot(_user, uid);
    } else {
      return User(email: '', uid: '');
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
      if (updateInfo['profilePic'] != null) {
        if (user.profilePic != null) {
          await StorageUserService.deleteProfilePicture(user.profilePic!);
        }

        if (updateInfo['profilePic'] == '') {
          updateInfo['profilePic'] = null;
        } else {
          String? downloadUrl = await StorageUserService.uploadProfilePicture(
              updateInfo['profilePic'], user.uid);

          if (downloadUrl == null) return;

          updateInfo['profilePic'] = downloadUrl;
        }
      }

      await _firestore.collection('users').doc(user.uid).update(updateInfo);

      Snackbar.success(
          'Data updating', 'The details were successfully updated');
    } catch (e) {
      Snackbar.error(
          'Data updating', 'There was an error updating the details');
    }
  }
}

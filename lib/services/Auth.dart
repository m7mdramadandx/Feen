import 'package:Feen/models/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userColection =
      Firestore.instance.collection('User');
  final DateTime timestamp = DateTime.now();
  UserData currentUser;

  Future addUserData(String uid, String fname, String lname, String email,
      String phone, String job) async {
    await userColection.document(uid).setData({
      'id': uid,
      'firstName': fname,
      'lastName': lname,
      'email': email,
      'phoneNumber': phone,
      'job': job,
      'survey': '0',
      'type': 'Normal',
      'levels': '1',
      'triesNumber': '0',
    });
  }

  // ignore: missing_return
  Future<String> createAuthUser(String email, String password, String fname,
      String lname, String phone, String job) async {
    String errorMessage;
    try {
      final FirebaseUser oldUser = _auth.currentUser as FirebaseUser;
      if (oldUser != null) {
        oldUser.delete();
      } else {
        print('delete error');
      }
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentUser = await addUserData(
          result.user.uid, fname, lname, result.user.email, phone, job);
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "كلمة المرور ضعيفة";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "البريد الأاكتروني مستخدم من قبل";
          break;
        default:
          errorMessage = "اعد المحاولة لاحقا";
      }
      if (errorMessage != null) {
        Fluttertoast.showToast(msg: errorMessage);
        return null;
      }
    }
    return "done";
  }

// ignore: non_constant_identifier_names
  Future<UserData> CurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    DocumentSnapshot doc = await userColection.document(user.uid).get();
    return UserData.fromDocument(doc);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateEmail(String email) async {
    FirebaseUser user = _auth.currentUser as FirebaseUser;
    user.updateEmail(email);
  }

  Future updatePassword(String password) async {
    String errorMessage;
    FirebaseUser user =
        (await FirebaseAuth.instance.currentUser) as FirebaseUser;
    user.updatePassword(password).catchError((error) {
      switch (error.code) {
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "كلمة المرور ضعيفة";
          break;
        default:
          errorMessage = "اعد المحاولة لاحقا";
      }
      if (errorMessage != null) {
        Fluttertoast.showToast(msg: errorMessage);
      }
    });
  }

  Future resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}

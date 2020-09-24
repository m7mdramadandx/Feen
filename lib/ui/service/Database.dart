import 'package:Fen/data/model/History.dart';
import 'package:Fen/data/model/PlaceResult.dart';
import 'package:Fen/data/model/userData.dart';
import 'package:Fen/ui/service/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:Fen/ui/screen/Dashboard.dart';

class DatabaseService {
  static bool crowd = false;
  static bool money = false;
  static bool status = false;
  String points;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference surveyColection =
      Firestore.instance.collection('Survey');
  final CollectionReference userColection =
      Firestore.instance.collection('User');
  //UserData currentUser;
  static List<History> objectHistory;
  static String historyKey = "null";

  // ignore: missing_return
  Future<String> addSurvey(int c1, int c2, int m1, int m2, int s1, int s2,
      String date, String hour, String atmID, String bankName) async {
    if (c1 > c2) {
      crowd = true;
    }
    if (c2 > c1) {
      crowd = false;
    }
    if (m1 > m2) {
      money = true;
    }
    if (m2 > m1) {
      money = false;
    }
    if (s1 > s2) {
      status = true;
    }
    if (s2 > s1) {
      status = false;
    }
    try {
      FirebaseUser user = await _auth.currentUser();
      String uid = user.uid.toString();

      await surveyColection
          .document(bankName)
          .collection(atmID)
          .document(date)
          .collection(hour)
          .document()
          .setData({
        'crowd': crowd,
        'enoughMoney': money,
        'type': status,
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await userColection
          .document(uid)
          .collection("Survey")
          .document(date)
          .collection(atmID)
          .document()
          .setData({
        'crowd': crowd,
        'enoughMoney': money,
        'type': status,
        'atmID': atmID,
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future editData(String attribute, String x) async {
    currentUser = await AuthServices().CurrentUser();
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid.toString();
    try {
      await userColection.document(uid).updateData({
        attribute: x,
      });
      currentUser = await AuthServices().CurrentUser();
    } catch (e) {
      print(" **************");
    }
  }

  Future updatePoints() async {
    currentUser = await AuthServices().CurrentUser();
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid.toString();
    try {
      int p = int.tryParse(currentUser.survey);
      p += 1;
      points = p.toString();
      await userColection.document(uid).updateData({
        'survey': points,
      });
      if (p > 8) {
        await userColection.document(uid).updateData({
          'type': 'Premium',
          'levels': '2',
        });
      }
      currentUser = await AuthServices().CurrentUser();
    } catch (e) {
      print(" **************");
    }
  }

  void checkIfdeposid(String atmID) async {
    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid.toString();
    int yes = 0;
    int no = 0;
    Firestore.instance
        .collection('User')
        .document(uid)
        .collection("Survey")
        .document()
        .collection(atmID)
        .where('atmID', isEqualTo: atmID)
        .getDocuments()
        .then((QuerySnapshot doc) {
      if (doc.documents.isNotEmpty) {
        yes = doc.documents.length;
      }
    });
  }

  void atmStatus(String bankName, String atmLatLng) {
    int yes = 0;
    int no = 0;
    var now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    String currentTime = "${now.hour.toString().padLeft(2, '0')} ";
    Firestore.instance
        .collection('Survey')
        .document(bankName)
        .collection(atmLatLng)
        .document(date)
        .collection(currentTime)
        .where('crowd', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot doc) {
      if (doc.documents.isNotEmpty) {
        yes = doc.documents.length;

        Firestore.instance
            .collection('Survey')
            .document(bankName)
            .collection(atmLatLng)
            .document(date)
            .collection(currentTime)
            .where('crowd', isEqualTo: false)
            .getDocuments()
            .then((QuerySnapshot doc) {
          if (doc.documents.isNotEmpty) {
            no = doc.documents.length;

            if (yes > no) {
              Firestore.instance
                  .collection('Survey')
                  .document(bankName)
                  .collection(atmLatLng)
                  .document(date)
                  .collection(currentTime)
                  .document('crowd')
                  .setData({
                'crowd': true,
              });
            } else {
              Firestore.instance
                  .collection('Survey')
                  .document(bankName)
                  .collection(atmLatLng)
                  .document(date)
                  .collection(currentTime)
                  .document('crowd')
                  .setData({
                'crowd': false,
              });
            }
          }
        });
      }
    });
    Firestore.instance
        .collection('Survey')
        .document(bankName)
        .collection(atmLatLng)
        .document(date)
        .collection(currentTime)
        .where('enoughMoney', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot doc) {
      if (doc.documents.isNotEmpty) {
        yes = doc.documents.length;
        Firestore.instance
            .collection('Survey')
            .document(bankName)
            .collection(atmLatLng)
            .document(date)
            .collection(currentTime)
            .where('enoughMoney', isEqualTo: false)
            .getDocuments()
            .then((QuerySnapshot doc) {
          if (doc.documents.isNotEmpty) {
            no = doc.documents.length;
            if (yes > no) {
              Firestore.instance
                  .collection('Survey')
                  .document(bankName)
                  .collection(atmLatLng)
                  .document(date)
                  .collection(currentTime)
                  .document('enoughMoney')
                  .setData({
                'enoughMoney': true,
              });
            } else {
              Firestore.instance
                  .collection('Survey')
                  .document(bankName)
                  .collection(atmLatLng)
                  .document(date)
                  .collection(currentTime)
                  .document('enoughMoney')
                  .setData({
                'enoughMoney': false,
              });
            }
          }
        });
      }
    });
    Firestore.instance
        .collection('Survey')
        .document(bankName)
        .collection(atmLatLng)
        .document(date)
        .collection(currentTime)
        .where('type', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot doc) {
      if (doc.documents.isNotEmpty) {
        yes = doc.documents.length;

        Firestore.instance
            .collection('Survey')
            .document(bankName)
            .collection(atmLatLng)
            .document(date)
            .collection(currentTime)
            .where('type', isEqualTo: false)
            .getDocuments()
            .then((QuerySnapshot doc) {
          if (doc.documents.isNotEmpty) {
            no = doc.documents.length;

            if (yes > no) {
              Firestore.instance
                  .collection('Survey')
                  .document(bankName)
                  .collection(atmLatLng)
                  .document(date)
                  .collection(currentTime)
                  .document('type')
                  .setData({
                'type': true,
              });
            } else {
              Firestore.instance
                  .collection('Survey')
                  .document(bankName)
                  .collection(atmLatLng)
                  .document(date)
                  .collection(currentTime)
                  .document('type')
                  .setData({
                'type': false,
              });
            }
          }
        });
      }
    });

    //finalAtmResult(bankName, atmLatLng);
  }

  void finalAtmResult(String bankName, String atmID) async {
    var now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    String currentTime = "${now.hour.toString().padLeft(2, '0')} ";
    bool c, m, t;
    DocumentSnapshot doc1 = await Firestore.instance
        .collection('Survey')
        .document(bankName)
        .collection(atmID)
        .document(date)
        .collection(currentTime)
        .document('crowd')
        .get();
    if (doc1 != null) {
      doc1.data.forEach((key, value) {
        c = value;
      });
    } else {
      print("NULL");
    }

    DocumentSnapshot doc2 = await Firestore.instance
        .collection('Survey')
        .document(bankName)
        .collection(atmID)
        .document(date)
        .collection(currentTime)
        .document('enoughMoney')
        .get();
    if (doc2 != null) {
      doc2.data.forEach((key, value) {
        m = value;
      });
    } else {
      print("NULL");
    }

    DocumentSnapshot doc3 = await Firestore.instance
        .collection('Survey')
        .document(bankName)
        .collection(atmID)
        .document(date)
        .collection(currentTime)
        .document('type')
        .get();
    if (doc3 != null) {
      doc3.data.forEach((key, value) {
        t = value;
      });
    } else {
      print("NULL");
    }

    Firestore.instance
        .collection('ATM')
        .document(bankName)
        .collection(atmID)
        .document(date)
        .collection(currentTime)
        .document(atmID)
        .setData({
      'crowd': c,
      'enoughMoney': m,
      'type': t,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static renewTriesNumber() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference userColection =
    Firestore.instance.collection('User');
    currentUser = await AuthServices().CurrentUser();
    FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid.toString();
    var now = DateTime.now();
    if ((now.hour > 24) && (currentUser.triesNumber) > 3) {
      try {
        await userColection.document(uid).updateData({
          'triesNumber': 0,
        });
      } catch (e) {
        print(e + " **************");
      }
    } else {
      print('Lesaa');
    }
  }

  static updateTriesNumber(int number) async {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userColection =
  Firestore.instance.collection('User');
    currentUser = await AuthServices().CurrentUser();
     FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid.toString();
    try {
      await userColection.document(uid).updateData({
        'triesNumber': number,
      });
      currentUser = await AuthServices().CurrentUser();
    } catch (e) {
      print(" **************");
    }
  }

  static discoveredATMs(LatLng atmLatLng) async {
    CollectionReference cr = Firestore.instance.collection('User');
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    Map<String, String> atm = {"location": atmLatLng.toString()};
    try {
      cr
          .document(uid)
          .collection("DiscoveredATMs")
          .document(atmLatLng.toString())
          .setData(atm);
    } catch (e) {
      print(e + " **************");
    }
  }

  static visitedATMs(PlaceResult atm, String atmType) async {
    CollectionReference cr = Firestore.instance.collection('User');
    var now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    String currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    try {
      cr.document(uid).collection("History").document(atm.placeId).setData({
        "name": atm.name,
        "vicinity": atm.vicinity,
        "rating": atm.rating,
        "latitude": atm.geometry.location.lat,
        "longitude": atm.geometry.location.long,
        "type": atmType,
        "date": date,
        "time": currentTime,
      });
    } catch (e) {
      print(e + " **************");
    }
  }

  static void loadHistory() async {
    CollectionReference cr = Firestore.instance.collection('User');
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    objectHistory = new List<History>();
    objectHistory.clear();
    try {
      cr
          .document(uid)
          .collection("History")
          .orderBy('date', descending: true)
          .snapshots()
          .listen((data) =>
          data.documents.forEach((doc) {
            var history = History.fromJson(doc.data);
            objectHistory.add(history);
            historyKey = "found";
          }));
      if (objectHistory.isEmpty) historyKey = "notFound";
    } catch (e) {
      print(e + " **************");
      historyKey = "notFound";
    }
    objectHistory.sort((a, b) => b.time.compareTo(a.time));
//    objectHistory.sort((a, b) => b.date.compareTo(a.date));
  }
}

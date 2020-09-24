import 'dart:convert';
import 'dart:math';

import 'package:Fen/data/model/PlaceResponse.dart';
import 'package:Fen/data/model/PlaceResult.dart';
import 'package:Fen/data/model/userData.dart';
import 'package:Fen/ui/service/Auth.dart';
import 'package:Fen/ui/service/Database.dart';
import 'package:Fen/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Fen/ui/screen/Dashboard.dart';

class MapService {
  //static UserData currentUser;
  static double latitude, longitude;
  static int distance;
  static List<PlaceResult> objectAtm, objectBank;
  static String bankKey = "null", atmKey = "null", keyword1 = "";
  static String keyword2 = "", keyword3 = "", keyword4 = "";
  static String keyword5 = "", keyword6 = "";
  static List<PlaceResult> places = new List<PlaceResult>();

  /*static getCurrentUser() async {
    currentUser = await AuthServices().CurrentUser();
  }*/

  static setLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }

  static checkTrisNumber() {
    //getCurrentUser();
    print("//////////////////////////////////");
    print(currentUser.triesNumber);
    if (currentUser.triesNumber > 3) {
      print('keteer ' + currentUser.triesNumber.toString());
      return false;
    } else {
      return true;
    }
  }

  static getNearbyAtm(String bankName, String operationType) async {
    objectAtm = new List<PlaceResult>();
    DatabaseService.renewTriesNumber();
    if (checkTrisNumber() == false) {
      Fluttertoast.showToast(msg: "عذرا لقد استهلكت الثلاث محولات المجانين");
      atmKey = "overTries";
      print("The Key is " + atmKey);
      return objectAtm;
    } else {
      objectAtm.clear();
      atmKey = "null";
      checkKeyword(bankName);
      String _url =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
          "location=$latitude,$longitude&rankby=distance&type=atm&keyword=$bankName&key=$apiKey";
      final response = await http.get(_url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "OK") {
          places =
              PlaceResponse.parseResults(data['results']).cast<PlaceResult>();
          for (int i = 0; i < places.length; i++) {
            getAtmName(i);
            getSimultaneousData(bankName, i, places[i].placeId);
          }
          if (operationType.contains("إيداع")) {
            List<PlaceResult> deposit = new List<PlaceResult>();
            objectAtm.forEach((f) {
              if (f.rating == 5) {
                deposit.add(f);
              }
            });
            objectAtm = deposit;
          }
          DatabaseService.updateTriesNumber(currentUser.triesNumber + 1);
        } else if (data['status'] == ("NOT_FOUND") ||
            data['status'] == ("ZERO_RESULTS")) {
          atmKey = "NOT_FOUND OR ZERO_RESULTS";
        } else if (data['status'] == ("OVER_QUERY_LIMIT")) {
          atmKey = "OVER_QUERY_LIMIT";
        }
      } else {
        atmKey = "other Error";
        throw Exception('An error occurred getting places nearby');
      }
      print("The Key is " + atmKey);
      return objectAtm;
    }
  }

  static getNearbyBank(String bankName) async {
    objectBank = new List<PlaceResult>();
    objectBank.clear();
    bankKey = "null";
    checkKeyword(bankName);
    String _url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        "location=$latitude,$longitude&rankby=distance&type=bank&keyword=$bankName&key=$apiKey";
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        bankKey = "Done";
        places =
            PlaceResponse.parseResults(data['results']).cast<PlaceResult>();
        for (int i = 0; i < places.length; i++) {
          getBankName(i);
        }
      } else if (data['status'] == ("NOT_FOUND") ||
          data['status'] == ("ZERO_RESULTS")) {
        bankKey = "NOT_FOUND OR ZERO_RESULTS";
      } else if (data['status'] == ("OVER_QUERY_LIMIT")) {
        bankKey = "OVER_QUERY_LIMIT";
      }
    } else {
      bankKey = "other Error";
      throw Exception('An error occurred getting places nearby');
    }
    print("The Key is " + bankKey);
    return objectBank;
  }

  static getSimultaneousData(String bankName, int index, String atmID) {
    var now = DateTime.now();
    String currentDay = DateFormat('dd.MM.yyyy').format(now);
    String currentHour = "${now.hour.toString().padLeft(2, '0')}";
    Firestore.instance
        .collection('ATM')
        .document(bankName)
        .collection(atmID)
        .document(currentDay)
        .collection(currentHour)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
      objectAtm[index].crowd = doc.data['crowd'];
      objectAtm[index].type = doc.data['type'];
      objectAtm[index].enoughMoney = doc.data['enoughMoney'];
//              objectAtm[index].rating = doc.data['rating'];
    }));
  }

  static getAtmName(int x) {
    if (places[x].name.contains(keyword1) ||
        places[x].name.contains(keyword2) ||
        places[x].name.contains(keyword3) ||
        places[x].name.contains(keyword4) ||
        places[x].name.contains(keyword5) ||
        places[x].name.contains(keyword6)) {
      atmKey = "found";
      places[x].distance = calculateDistance(latitude, longitude,
          places[x].geometry.location.lat, places[x].geometry.location.long)
          .toStringAsFixed(1);
      objectAtm.add(places[x]);
    }
  }

  static getBankName(int x) {
    if (places[x].name.contains(keyword1) ||
        places[x].name.contains(keyword2) ||
        places[x].name.contains(keyword3) ||
        places[x].name.contains(keyword4) ||
        places[x].name.contains(keyword5) ||
        places[x].name.contains(keyword6)) {
      bankKey = "found";
      places[x].distance = calculateDistance(latitude, longitude,
          places[x].geometry.location.lat, places[x].geometry.location.long)
          .toStringAsFixed(1);
      objectBank.add(places[x]);
    }
  }

  static checkKeyword(String bankName) {
    if (bankName == "البنك الأهلي المصري") {
      keyword1 = "NBE";
      keyword2 = "البنك الأهلي المصر";
      keyword3 = "البنك الاهلي المصر";
      keyword4 = "National Bank Of Egypt";
      keyword5 = "Ahly";
      keyword6 = "Nbe";
    } else if (bankName == "بنك مصر") {
      keyword1 = "Misr Bank";
      keyword2 = "بنك مصر";
      keyword3 = "Banque Misr";
      keyword4 = "Bank of Egypt";
      keyword5 = "maser";
      keyword6 = "Banquemisr";
    } else if (bankName == "بنك القاهرة") {
      keyword1 = "Cairo Bank";
      keyword2 = "بنك القاهرة";
      keyword3 = "Banque du caire";
      keyword4 = "El Qahra";
      keyword5 = "El Kahra";
      keyword6 = "Al Qahera";
    }
  }

  static double calculateDistance(double srcLat, double srcLng, double distLat, double distLng) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((distLat - srcLat) * p) / 2 +
        c(srcLat * p) * c(distLat * p) * (1 - c((distLng - srcLng) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

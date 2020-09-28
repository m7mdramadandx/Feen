import 'dart:io';

import 'package:Feen/models/PlaceResult.dart';
import 'package:Feen/models/userData.dart';
import 'package:Feen/services/Auth.dart';
import 'package:Feen/services/Database.dart';
import 'package:Feen/ui/widgets/button_widget.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;

import 'Dashboard.dart';

// ignore: must_be_immutable
class SurveyScreen extends StatefulWidget {
  PlaceResult atm;
  String bankName;

  SurveyScreen({this.atm, this.bankName});

  @override
  _SurveyScreenState createState() =>
      _SurveyScreenState(atm: atm, bankName: bankName);
}

class _SurveyScreenState extends State<SurveyScreen> {
  PlaceResult atm;
  String bankName;

  _SurveyScreenState({this.atm, this.bankName});

  int _group1, _group2, _group3;
  UserData currentUser;
  int crowdYes = 0, crowdNo = 0, moneyYes = 0, moneyNo = 0;
  int statusYes = 0, statusNo = 0;
  String survey;
  static BitmapDescriptor pin;
  DatabaseService databaseService = DatabaseService();
  static GoogleMapController _controller;
  List<Marker> markers = <Marker>[];

  @override
  void initState() {
    super.initState();
//    checkInternet();
    getcurrentuser();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      noInternetConnection();
    }
  }

  Future<bool> noInternetConnection() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('عذرا ، لا يوجد اتصال بالإنترنت',
                style: TextStyle(fontFamily: 'Cairo', color: primaryColor)),
            content: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 40,
                child: Image.asset('lib/assets/icons/noInternet.png')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
          ),
        )) ??
        false;
  }

  getcurrentuser() async {
    currentUser = await AuthServices().CurrentUser();
    print('Survey');
    survey = currentUser.survey;
  }

  void _setStyle(GoogleMapController controller) async {
    String selectedValue = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/light_map.json');
    controller.setMapStyle(selectedValue);
  }

  setPin() {
    markers.add(Marker(
        markerId: MarkerId("Id"),
        icon: pin,
        position: LatLng(atm.geometry.location.lat, atm.geometry.location.long),
        infoWindow: InfoWindow(title: atm.name, snippet: atm.vicinity),
        onTap: () {
          moveCamera(
              LatLng(atm.geometry.location.lat, atm.geometry.location.long));
        }));
  }

  moveCamera(LatLng latLng) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16.0)));
  }

  createMarker(context) {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
            configuration, 'lib/assets/icons/withdrawPin.png')
        .then((_pin) {
      setState(() {
        pin = _pin;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    createMarker(context);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    setPin();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  flex: 35,
                  child: GoogleMap(
                    buildingsEnabled: true,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    markers: Set<Marker>.of(markers),
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        _controller = controller;
                        _setStyle(controller);
                      });
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(atm.geometry.location.lat,
                            atm.geometry.location.long),
                        zoom: 16),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Expanded(
                  flex: 65,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              questionItem('lib/assets/icons/crowd.png',
                                  'هل الماكينة مزدحمة الأن؟', 1, _group1),
                              SizedBox(height: 8),
                              questionItem(
                                  'lib/assets/icons/enoughMoney.png',
                                  "هل عادة تتوفر النقود الكافية بالماكينة؟",
                                  2,
                                  _group2),
                              SizedBox(height: 8),
                              questionItem(
                                  'lib/assets/icons/atm.png',
                                  "هل تتوفر خدمة الإيداع بالماكينة؟",
                                  3,
                                  _group3),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        RoundedButton(
                          onPressed: () async {
                            var now = DateTime.now();
                            String date =
                                intl.DateFormat('dd.MM.yyyy').format(now);
                            String currentTime =
                                "${now.hour.toString().padLeft(2, '0')} ";
                            databaseService.addSurvey(
                                crowdYes,
                                crowdNo,
                                moneyYes,
                                moneyNo,
                                statusYes,
                                statusNo,
                                date,
                                currentTime,
                                atm.placeId,
                                bankName);
                            databaseService.updatePoints();
                            databaseService.atmStatus(bankName, atm.placeId);
                            int p = int.tryParse(currentUser.survey);
                            p += 1;
                            survey = p.toString();

                            checkIfdeposid(atm.placeId);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DashboardScreen(userSurvey: survey);
                                },
                              ),
                            );
                          },
                          color: primaryColor,
                          textColor: Colors.white,
                          title: 'تأكيد',
                          leftMarginValue: 0,
                        )
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget questionItem(
      String imgPath, String title, int questionNumber, int _group) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTileCard(
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 30,
            child: Image.asset(imgPath)),
        title: Text(title, style: TextStyle(fontFamily: 'Cairo')),
        subtitle: Text(' إضغط للإجابة',
            style: TextStyle(fontFamily: 'Cairo', color: grey)),
        baseColor: Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        expandedColor: silver,
        children: <Widget>[
          Divider(thickness: 1.0, height: 1.0),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: [
                    Text('نعم',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    Radio(
                        activeColor: primaryColor,
                        value: 1,
                        groupValue: _group,
                        onChanged: (value) {
                          setState(() {
                            if (questionNumber == 1) {
                              crowdNo = 0;
                              crowdYes = 1;
                              _group1 = value;
                            }
                            if (questionNumber == 2) {
                              moneyNo = 0;
                              moneyYes = 1;
                              _group2 = value;
                            }
                            if (questionNumber == 3) {
                              statusYes = 1;
                              statusNo = 0;
                              _group3 = value;
                            }
                            _group = value;
                          });
                        }),
                  ],
                ),
                Row(
                  children: [
                    Text('لا',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    Radio(
                        activeColor: Colors.red,
                        value: 0,
                        groupValue: _group,
                        onChanged: (value) {
                          setState(() {
                            if (questionNumber == 1) {
                              crowdNo = 1;
                              crowdYes = 0;
                              _group1 = value;
                            }
                            if (questionNumber == 2) {
                              moneyNo = 1;
                              moneyYes = 0;
                              _group2 = value;
                            }
                            if (questionNumber == 3) {
                              statusYes = 1;
                              statusNo = 0;
                              _group3 = value;
                            }

                            _group = value;
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: new AlertDialog(
              content: new Text('هل تريد حقًا الخروج من الاستبيان؟',
                  style: TextStyle(fontFamily: 'Cairo', color: grey)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              backgroundColor: silver,
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('لا',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    super.dispose();
                  },
                  child: new Text('نعم',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  void checkIfdeposid(String atmID) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid.toString();

    Firestore.instance
        .collection('User')
        .document(uid)
        .collection("History")
        .where('latitude', isEqualTo: atm.geometry.location.lat)
        .getDocuments()
        .then((QuerySnapshot doc) {
      print(doc.documents.length);
      if (doc.documents.isNotEmpty) {
        print("YEEEEEEEEEEEEEEEEEEEEEEES");
      }
    });
  }
}

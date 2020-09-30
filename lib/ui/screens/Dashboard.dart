import 'package:Feen/models/userData.dart';
import 'package:Feen/services/Auth.dart';
import 'package:Feen/services/Database.dart';
import 'package:Feen/ui/screens/AtmFinder.dart';
import 'package:Feen/ui/widgets/animation/FadeAnimation.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';

import 'BankFinder.dart';
import 'Profile.dart';
import 'Tips.dart';

final CollectionReference usersRef = Firestore.instance.collection('User');
UserData currentUser;

// ignore: must_be_immutable
class DashboardInfo extends StatefulWidget {
  String userSurvey;

  DashboardInfo({this.userSurvey});

  @override
  _DashboardInfoState createState() =>
      _DashboardInfoState(userSurvey: this.userSurvey);
}

class _DashboardInfoState extends State<DashboardInfo> {
  String userSurvey;

  _DashboardInfoState({this.userSurvey});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(userSurvey: userSurvey);
  }
}

class DashboardScreen extends StatefulWidget {
  String userSurvey;

  DashboardScreen({this.userSurvey});

  static String id = 'dashboard_page';

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(userSurvey: userSurvey);
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userSurvey;

  _DashboardScreenState({this.userSurvey});

  int restSurveys;
  Position currentPosition;
  Color s1 = lightGreen;
  Color s2 = lightGreen;
  Color s3 = lightGreen;
  Color s4 = lightGreen;
  Color s5 = lightGreen;
  Color s6 = lightGreen;
  Color s7 = lightGreen;
  Color s8 = lightGreen;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    Geolocator()
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).then((position) {
        if (mounted) {
          setState(() {
            currentPosition = position;
          });
        }
      }).catchError((e) {
        print(e + " *********** Error in getLocation Method ");
        Navigator.of(context).pop(true);
        super.dispose();
      });
  }

  getCurrentUser() async {
    currentUser = await AuthServices().CurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    restSurveys = 8 - int.parse(userSurvey);
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    final screenWidth = (MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.top);
    String freeUserStatus =
        "متبقى لك " + restSurveys.toString() + " من اصل 8 للوصول للحساب المميز";
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: primaryColor,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(children: <Widget>[
              FadeAnimation(
                1,
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(8, 32, 0, 0),
                  child: IconButton(
                      icon: Icon(Ionicons.md_notifications_outline,
                          color: gold, size: 32),
                      onPressed: null),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32),
                    FadeAnimation(
                      1,
                      Text('اهلا بك',
                          style: normalText.apply(color: Colors.white)),
                    ),
                    FadeAnimation(
                      1.1,
                      Text('الصفحة الرئيسية',
                          style: title.apply(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16, screenHeight * 0.03, 16, 8),
                    height: screenHeight * 0.2,
                    child: FadeAnimation(
                      1.2,
                      Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Expanded(
                                            child: AutoSizeText(
                                              "سجل الاستبيانات",
                                              minFontSize: 24,
                                              style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor),
                                            ),
                                          ),
                                          Expanded(child: survey()),
                                          Expanded(
                                            child: AutoSizeText(
                                              freeUserStatus,
                                              maxFontSize: 12,
                                              style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: primaryColor),
                                            ),
                                          )
                                        ])),
                                Container(
                                    padding: EdgeInsets.only(left: 4),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 45,
                                        child: Image.asset(
                                            'lib/assets/icons/survey.png')))
                              ])),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FadeAnimation(
                                1.6,
                                Row(children: <Widget>[
                                  Expanded(
                                    child: cardWidget('أفضل ماكينة',
                                        'lib/assets/icons/atm.png', () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  AtmFinder(currentPosition)));
                                    }),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  Expanded(
                                    child: cardWidget(
                                        'أفضل بنك', 'lib/assets/icons/bank.png',
                                        () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  BankFinder(currentPosition)));
                                    }),
                                  ),
                                ]),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              FadeAnimation(
                                1.8,
                                Row(children: <Widget>[
                                  Expanded(
                                      child: cardWidget('الصفحة الشخصية',
                                          'lib/assets/icons/user.png', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => ProfileScreen(
                                                userData: currentUser,
                                                infoChanged: false)));
                                  })),
                                  SizedBox(width: screenWidth * 0.05),
                                  Expanded(
                                      child: cardWidget("إرشادات و تعليمات",
                                          'lib/assets/icons/tips.png', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => Tips()));
                                  }))
                                ]),
                              ),
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ]),
          )),
    );
  }

  Widget survey() {
    int p = int.tryParse(userSurvey);
    if (p == 1) {
      s1 = primaryColor;
    } else if (p == 2) {
      s1 = primaryColor;
      s2 = primaryColor;
    } else if (p == 3) {
      s1 = primaryColor;
      s2 = primaryColor;
      s3 = primaryColor;
    } else if (p == 4) {
      s1 = primaryColor;
      s2 = primaryColor;
      s3 = primaryColor;
      s4 = primaryColor;
    } else if (p == 5) {
      s1 = primaryColor;
      s2 = primaryColor;
      s3 = primaryColor;
      s4 = primaryColor;
      s5 = primaryColor;
    } else if (p == 6) {
      s1 = primaryColor;
      s2 = primaryColor;
      s3 = primaryColor;
      s4 = primaryColor;
      s5 = primaryColor;
      s6 = primaryColor;
    } else if (p == 7) {
      s1 = primaryColor;
      s2 = primaryColor;
      s3 = primaryColor;
      s4 = primaryColor;
      s5 = primaryColor;
      s6 = primaryColor;
      s7 = primaryColor;
    } else if (p == 8) {
      s1 = primaryColor;
      s2 = primaryColor;
      s3 = primaryColor;
      s4 = primaryColor;
      s6 = primaryColor;
      s7 = primaryColor;
      s8 = primaryColor;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Ionicons.ios_paper, color: s1),
        Icon(Ionicons.ios_paper, color: s2),
        Icon(Ionicons.ios_paper, color: s3),
        Icon(Ionicons.ios_paper, color: s4),
        Icon(Ionicons.ios_paper, color: s5),
        Icon(Ionicons.ios_paper, color: s6),
        Icon(Ionicons.ios_paper, color: s7),
        Icon(Ionicons.ios_paper, color: s8),
      ],
    );
  }

  Widget cardWidget(String title, String img, Function onTap) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.25,
      child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: InkWell(
              onTap: onTap,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        child: Image.asset(img)),
                    Text(title, style: subtitle.apply(fontSizeFactor: 0.8))
                  ]))),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              content: Text('هل تريد حقًا الخروج من التطبيق؟',
                  style: TextStyle(fontFamily: 'Cairo', color: grey)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              backgroundColor: silver,
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('لا',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
                FlatButton(
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
}

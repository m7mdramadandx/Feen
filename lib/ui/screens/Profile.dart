import 'package:Feen/models/userData.dart';
import 'package:Feen/services/Auth.dart';
import 'package:Feen/services/Database.dart';
import 'package:Feen/ui/widgets/ProfileHeader.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/types/gf_button_type.dart';

import 'Dashboard.dart';
import 'EditProfile.dart';
import 'History.dart';
import 'Login.dart';

class ProfileScreen extends StatefulWidget {
  final UserData userData;
  final bool infoChanged;

  ProfileScreen({this.userData, this.infoChanged});

  @override
  _ProfileScreenState createState() => _ProfileScreenState(
      userData: this.userData, infoChanged: this.infoChanged);
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  UserData userData;
  bool infoChanged;

  _ProfileScreenState({this.userData, this.infoChanged});

  static String firstName, lastName, email;
  static String phone, bank = "لم يحدد بعد", status;
  static bool historyKey = false, informationKey = true;
  Color historyButtonColor = Colors.white, informationButtonColor = silver;
  FancyDrawerController _controller;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    DatabaseService.loadHistory();
    historyButtonColor = Colors.white;
    informationButtonColor = silver;
    informationKey = true;
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      });
    isInfoChanged(widget.infoChanged);
  }

  isInfoChanged(bool key) {
    if (key == true) _controller.toggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getCurrentUser() async {
    if (infoChanged == true) {
      currentUser = await AuthServices().CurrentUser();
      currentUser = await AuthServices().CurrentUser();
      firstName = currentUser.firstName;
      lastName = currentUser.lastName;
      phone = currentUser.phoneNumber;
      email = currentUser.email;
      status = currentUser.job;
    } else {
      firstName = userData.firstName;
      lastName = userData.lastName;
      phone = userData.phoneNumber;
      email = userData.email;
      status = userData.job;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    return FancyDrawerWrapper(
      backgroundColor: Colors.white,
      controller: _controller,
      cornerRadius: 25,
      hideOnContentTap: true,
      drawerItems: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 24),
              width: 180,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: grey, width: 2),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              child: Column(
                children: <Widget>[
                  GFButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  EditDataScreen(userData: currentUser)));
                    },
                    text: "تعديل البيانات",
                    fullWidthButton: true,
                    color: primaryColor,
                    position: GFPosition.end,
                    icon: Icon(FlutterIcons.account_edit_outline_mco),
                    textStyle: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  GFButton(
                    fullWidthButton: true,
                    onPressed: () {
                      Fluttertoast.showToast(msg: "قريبا");
                    },
                    text: "عن التطبيق",
                    color: primaryColor,
                    position: GFPosition.end,
                    icon: Icon(FlutterIcons.alert_box_outline_mco),
                    textStyle: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  GFButton(
                    fullWidthButton: true,
                    onPressed: () {
                      Fluttertoast.showToast(msg: "قريبا");
                    },
                    text: "تواصل معنا",
                    color: primaryColor,
                    position: GFPosition.end,
                    icon: Icon(FlutterIcons.contacts_ant),
                    textStyle: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: 180,
              child: GFButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new LoginScreen()));
                },
                text: "تسجيل الخروج",
                color: primaryColor,
                type: GFButtonType.outline2x,
                position: GFPosition.end,
                icon: Icon(FlutterIcons.exit_to_app_mdi),
                textStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ],
        )
      ],
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(220),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 16, 0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Ionicons.md_arrow_round_forward,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 2),
                        Container(
                          child: AutoSizeText(
                            "الصفحة الشخصية",
                            maxFontSize: 40,
                            minFontSize: 20.0,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          height: screenHeight * .07,
                        ),
                      ],
                    ),
                  ),
                  ProfileHeader(
                    avatar: AssetImage('lib/assets/icons/user.png'),
                    firstName: firstName != null ? firstName : "االاسم الأول",
                    lastName: lastName != null ? lastName : "الاسم الأخير",
                    radius: screenHeight * .07,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(8, 32, 0, 0),
                    child: IconButton(
                        icon: Icon(FlutterIcons.md_menu_ion,
                            color: gold, size: 32),
                        onPressed: () {
                          _controller.toggle();
                        }),
                  ),
                ],
              ),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    color: informationButtonColor,
                    onPressed: () {
                      setState(() {
                        informationKey = true;
                        historyButtonColor = Colors.white;
                        informationButtonColor = silver;
                        historyKey = false;
                      });
                    },
                    child: AutoSizeText(
                      'المعملومات الشخصية',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                      maxFontSize: 16,
                      minFontSize: 14,
                    ),
                  ),
                  FlatButton(
                    color: historyButtonColor,
                    onPressed: () {
                      setState(() {
                        informationKey = false;
                        historyKey = true;
                        informationButtonColor = Colors.white;
                        historyButtonColor = silver;
                      });
                    },
                    child: AutoSizeText(
                      'السجل',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                      maxFontSize: 16,
                      minFontSize: 14,
                    ),
                  ),
                ],
              ),
              _widget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widget() {
    if (informationKey == true) {
      return informationWidget();
    } else if (historyKey == true) {
      return historyWidget();
    } else {
      return informationWidget();
    }
  }

  Widget historyWidget() {
    if (DatabaseService.historyKey == "found") {
      return History();
    } else if (DatabaseService.historyKey == "notFound") {
      return noResult();
    } else {
      return loadResult();
    }
  }

  Widget informationWidget() {
    final screenSize = MediaQuery.of(context).size;
    return new Container(
      alignment: Alignment.center,
      height: screenSize.height * 0.5,
      width: screenSize.width,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.email,
                  color: primaryColor,
                )),
            title: Text(
              "البريد الاكتروني",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(email != null ? email : email = "البريد الاكتروني",
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    color: grey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(
              height: 0.5,
              thickness: 1.0,
              color: Colors.black12,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.smartphone,
                  color: primaryColor,
                )),
            title: Text(
              "رقم الهاتف",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(phone != null ? phone : phone = "رقم الهاتف",
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    color: grey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(
              height: 0.5,
              thickness: 1.0,
              color: Colors.black12,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.business_center,
                  color: primaryColor,
                )),
            title: Text(
              "الحالة",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(status != null ? status : status = "الحالة",
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    color: grey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(
              height: 0.5,
              thickness: 1.0,
              color: Colors.black12,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  FlutterIcons.bank_faw,
                  color: primaryColor,
                )),
            title: Text(
              "البنك التابع له",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(bank != null ? bank : bank = "لم يحدد بعد",
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    color: grey)),
          ),
        ],
      ),
    );
  }
}

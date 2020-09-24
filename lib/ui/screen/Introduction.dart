import 'package:Fen/data/model/userData.dart';
import 'package:Fen/ui/screen/Dashboard.dart';
import 'package:Fen/ui/service/Auth.dart';
import 'package:Fen/util//button_widget.dart';
import 'package:Fen/util//introScreenContent.dart';
import 'package:Fen/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Login.dart';

class IntroductionScreen extends StatefulWidget {
  static String id = 'introscreen';

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserData currentUser;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    if (await _auth.currentUser() != null) {
      currentUser = await AuthServices().CurrentUser();
    } else {
      Route route = MaterialPageRoute(builder: (builder) => LoginScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ScreenContent(),
          RoundedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DashboardScreen(userSurvey: currentUser.survey);
                  },
                ),
              );
            },
            leftMarginValue: 0,
            title: 'ابدأ',
            color: primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
